defmodule AssistantWeb.PageLive do
  use AssistantWeb, :live_view

  alias Assistant.Dispatch

  @impl true
  def mount _params, _session, socket do
    socket =
      socket
      |> assign(:current_page, "1")
      |> assign(:selected_item, -1)
      |> assign(:download_link_generated, false)
    {:ok, socket}
  end

  def handle_params _params, _url, socket do

    path = "priv/#{socket.id}.bin"

    if File.exists?(path) do
      list =
        path
        |> File.read!
        |> :erlang.binary_to_term
      File.rm! path
      socket =
        socket
        |> assign(:list, list)
        |> assign(:current_page, "2")
        |> assign(:selected_item, -1)
      {:noreply, socket}
    else
      {:noreply, socket}
    end
  end

  def handle_event "back", _params, socket do
    socket =
      socket
      |> assign(:current_page, "1")
    {:noreply, socket}
  end

  def handle_event "download", _params, socket do

    path = "priv/#{socket.id}.bin"
    File.write! path, :erlang.term_to_binary(socket.assigns.list)

    csv = to_csv elem(socket.assigns.list, 1)

    File.write! "priv/#{String.replace(socket.id, "phx-", "")}.csv", csv

    socket =
      socket
      |> assign(:download_link_generated, true)
    {:noreply, socket}
  end

  def handle_info {type, raw_references}, socket do
    socket =
      socket
      |> assign(:current_page, "2")
      |> assign(:list, {type, Dispatch.query(type, raw_references)})
    {:noreply, socket}
  end

  defp to_csv list do
    entries = Enum.map list, fn [_,y,_] ->
      "#{List.first(y["title"])}\n"
    end
    "title\n#{entries}"
  end
end
