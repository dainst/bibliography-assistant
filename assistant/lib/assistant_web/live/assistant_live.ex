defmodule AssistantWeb.AssistantLive do
  use AssistantWeb, :live_view

  alias Assistant.Translator
  alias Assistant.Dispatch

  @impl true
  def mount _params, _session, socket do
    socket =
      socket
      |> assign(:current_page, "1")
      |> assign(:selected_item, -1)
      |> assign(:lang, "de")
      |> assign(:download_link_generated, false)
    {:ok, socket}
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
    socket =
      socket
      |> push_event(:request_language, %{})
    {:noreply, socket}
  end

  @impl true
  def handle_event "new_search", _params, socket do
    socket =
      socket
      |> assign(:current_page, "1")
    {:noreply, socket}
  end

  def handle_event "select_language", language, socket do
    socket =
      socket
      |> assign(:lang, language)
    {:noreply, socket}
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

    socket =
      socket
      |> assign(:download_link_generated, true)
    {:noreply, socket}
  end

  @impl true
  def handle_info {type, raw_references}, socket do

    result = Dispatch.query(type, raw_references)

    case result do
      {:error, msg} ->
        msg = Translator.translate(msg, socket.assigns.lang)
        socket =
          socket
          |> put_flash(:error, msg)
        {:noreply, socket}
      result ->
        socket =
          socket
          |> assign(:current_page, "2")
          |> assign(:list, {type, result})
        {:noreply, socket}
    end
  end
end
