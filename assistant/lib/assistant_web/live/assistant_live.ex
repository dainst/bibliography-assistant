defmodule AssistantWeb.AssistantLive do
  use AssistantWeb, :live_view

  alias Assistant.Translator
  alias Assistant.Dispatch
  alias AssistantWeb.References
  alias AssistantWeb.Correspondence
  alias AssistantWeb.SearchDetails


  import AssistantWeb # TODO necessary?

  @impl true
  def mount _params, _session, socket do
    socket
    |> assign(:current_page, "1")
    |> assign(:selected_item, -1)
    |> assign(:lang, "de")
    |> assign(:download_link_generated, false)
    |> return_ok
  end

  @impl true
  def handle_params _params, _url, socket do

    path = "priv/#{socket.id}.bin"

    unless File.exists?(path) do
      socket
    else
      list =
        path
        |> File.read!
        |> :erlang.binary_to_term
      File.rm! path
      socket
      |> assign(:list, list)
      |> assign(:current_page, "2")
      |> assign(:selected_item, -1)
    end
    socket
    |> push_event(:request_language, %{})
    |> return_noreply
  end

  @impl true
  def handle_event "new_search", _params, socket do
    socket
    |> assign(:current_page, "1")
    |> return_noreply
  end

  def handle_event "select_language", language, socket do
    socket
    |> assign(:lang, language)
    |> return_noreply
  end

  def handle_event "download", _params, socket do

    {parser, entries} = list = socket.assigns.list

    path = "priv/#{socket.id}.bin"
    File.write! path, :erlang.term_to_binary(list)

    csv = (case parser do
      "anystyle" -> &Assistant.AnystyleCsvBuilder.generate/1
      "grobid" -> &Assistant.GrobidCsvBuilder.generate/1
      "cermine" -> &Assistant.CermineCsvBuilder.generate/1
    end).(entries)

    File.write! "priv/#{String.replace(socket.id, "phx-", "")}.csv", csv

    socket
    |> assign(:download_link_generated, true)
    |> return_noreply
  end

  def handle_event "back_to_correspondence", _, socket do
    socket
    |> assign(:current_page, "2")
    |> return_noreply
  end

  def handle_event "go_to_search_details", %{ "idx" => idx }, socket do
    {idx, ""} = Integer.parse idx
    socket
    |> assign(:selected_item, idx)
    |> assign(:current_page, "3")
    |> push_event(:select_item, %{ idx: idx })
    |> return_noreply
  end

  @impl true
  def handle_info {parser, raw_references}, socket do

    result = Dispatch.query(parser, raw_references)

    case result do
      {:error, msg} -> handle_error msg, socket
      result ->
        socket
        |> assign(:current_page, "2")
        |> assign(:parser, parser)
        |> assign(:list, result)
    end
    |> return_noreply
  end

  def get_zenon_search_link list do

    results = Enum.map list, fn [_raw, _item, {{_api_suffix, _ui_suffix}, {_num_total_results, results}}] -> results end
    results = Enum.filter results, fn results -> length(results) == 1 end
    results = Enum.map results, fn results -> "\"#{List.first(results)["id"]}\"" end

    results = Enum.join(results, "+OR+")

    "https://zenon.dainst.org/Search/Results?lookfor=#{results}&type=SystemNo"
  end

  defp handle_error msg, socket do
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
