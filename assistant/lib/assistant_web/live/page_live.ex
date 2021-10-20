defmodule AssistantWeb.PageLive do
  use AssistantWeb, :live_view

  alias Assistant.Dispatch

  @impl true
  def mount _params, _session, socket do
    socket =
      socket
      |> assign(:current_page, "1")
      |> assign(:selected_item, -1)
    {:ok, socket}
  end

  def handle_event "back", _params, socket do
    socket =
      socket
      |> assign(:current_page, "1")
    {:noreply, socket}
  end

  def handle_info {type, raw_references}, socket do
    socket =
      socket
      |> assign(:current_page, "2")
      |> assign(:list, {type, Dispatch.query(type, raw_references)})
    {:noreply, socket}
  end
end
