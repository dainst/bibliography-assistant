defmodule AssistantWeb.AssistantLive do
  use AssistantWeb, :live_view

  alias Assistant.Translator
  alias Assistant.Dispatch
  alias AssistantWeb.ReferencesPageComponent
  alias AssistantWeb.CorrespondencePageComponent
  alias AssistantWeb.SearchDetailsPageComponent

  @impl true
  def mount _params, _session, socket do
    socket
    |> assign(:current_page, "references-page")
    |> assign(:selected_item, -1)
    |> assign(:lang, "de")
    |> assign(:show_details, false)
    |> assign(:show_spinner, false)
    |> assign(:download_link_generated, false)
    |> return_ok
  end

  @impl true
  def handle_params _params, _url, socket do

    path = "priv/#{socket.id}.bin"

    unless File.exists?(path) do
      socket
    else
      {parser, list} =
        path
        |> File.read!
        |> :erlang.binary_to_term
      File.rm! path
      socket
      |> assign(:list, list)
      |> assign(:show_details, false)
      |> assign(:parser, parser)
      |> assign(:current_page, "correspondence-page")
      |> assign(:selected_item, -1)
    end
    socket
    |> assign(:show_spinner, false)
    |> push_event(:request_language, %{})
    |> return_noreply
  end

  @impl true
  def handle_event "new_search", _params, socket do
    socket
    |> assign(:current_page, "references-page")
    |> assign(:show_spinner, false)
    |> return_noreply
  end

  def handle_event "toggle_details", _params, socket do
    socket
    |> assign(:show_details, !socket.assigns.show_details)
    |> return_noreply
  end

  def handle_event "select_language", language, socket do
    socket
    |> assign(:lang, language)
    |> return_noreply
  end

  def handle_event "download", _params, socket do

    delete_older_support_files "bin"
    delete_older_support_files "csv"
    generate_suport_files socket.assigns.parser, socket.assigns.list, socket.id

    socket
    |> assign(:download_link_generated, true)
    |> return_noreply
  end

  def handle_event "back_to_correspondence", _, socket do
    socket
    |> assign(:current_page, "correspondence-page")
    |> assign(:download_link_generated, false)
    |> push_event(:select_item, %{ idx: socket.assigns.selected_item })
    |> return_noreply
  end

  def handle_event "go_to_search_details", %{ "idx" => idx }, socket do
    {idx, ""} = Integer.parse idx
    socket
    |> assign(:selected_item, idx)
    |> assign(:current_page, "search-details-page")
    |> push_event(:select_item, %{ idx: idx })
    |> return_noreply
  end

  def handle_event "select", %{ "idx" => idx }, socket do
    {idx, _} = Integer.parse idx
    socket
    |> assign(:selected_item, idx)
    |> push_event("select", %{ idx: idx })
    |> return_noreply
  end

  def handle_event "select_zenon_item", %{ "id" => id }, socket do
    socket
    |> assign(:list, reselect_zenon_items(id, socket.assigns.list, socket.assigns.selected_item))
    |> return_noreply
  end

  @impl true
  def handle_info {_, {:error, msg}}, socket do
    socket
    |> handle_error(msg)
    |> assign(:show_spinner, false)
    |> return_noreply
  end

  def handle_info {:DOWN, _, :process, _, :normal}, socket do
    socket
    |> return_noreply
  end

  def handle_info {_, [_|_] = result}, socket do
    socket
    |> assign(:current_page, "correspondence-page")
    |> assign(:list, select_zenon_items(result))
    |> return_noreply
  end

  def handle_info({parser, raw_references}, socket) when is_binary(parser) do

    Task.async fn ->
      result = Dispatch.query parser, raw_references
      send self(), result
    end

    socket
    |> clear_flash
    |> assign(:parser, parser)
    |> assign(:show_spinner, true)
    |> return_noreply
  end

  defp generate_suport_files parser, list, socket_id do
    path = "priv/#{socket_id}.bin"
    File.write! path, :erlang.term_to_binary({parser, list})

    csv = (case parser do
      "anystyle" -> &Assistant.Anystyle.CsvBuilder.generate/1
      "grobid" -> &Assistant.Grobid.CsvBuilder.generate/1
    end).(list)

    File.write! "priv/#{String.replace(socket_id, "phx-", "")}.csv", csv
  end

  defp delete_older_support_files extension do
    Path.wildcard("priv/*.#{extension}")
    |> Enum.map(fn file ->
      {:ok, %{ mtime: {file_date, _file_time}}} = File.stat file

      if 1 < Date.diff (Date.from_erl! :erlang.date), (Date.from_erl! file_date) do
        File.rm! file
      end
    end)
  end

  defp reselect_zenon_items selected_zenon_id, list, selected_item do

    list = Enum.with_index list, fn list_item, idx ->
      if idx != selected_item do
        list_item
      else
        [raw, parsed, {suffixes, {num_total_results, results, previously_selected_zenon_item}}] = list_item

        selected_zenon_item = unless previously_selected_zenon_item["id"] == selected_zenon_id do
          Enum.find results, &(&1["id"] == selected_zenon_id)
        end
        [raw, parsed, {suffixes, {num_total_results, results, selected_zenon_item}}]
      end
    end
    list
  end

  defp select_zenon_items results do

    Enum.map results, fn result ->
      [raw, item, {suffixes, {num_total_results, zenon_results}}] = result
      zenon_data = {
        num_total_results,
        zenon_results,
        if length(zenon_results) == 1 do List.first(zenon_results) end
      }
      [raw, item, {suffixes, zenon_data}]
    end
  end

  defp handle_error socket, msg do
    put_flash socket, :error, translate_error(msg, socket.assigns.lang)
  end

  defp translate_error msg, lang do
    Translator.translate String.to_atom("error_#{Atom.to_string(msg)}"), lang
  end

  defp return_noreply socket do
    {:noreply, socket}
  end

  defp return_ok socket do
    {:ok, socket}
  end
end
