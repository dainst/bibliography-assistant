defmodule AssistantWeb.PageLive do
  use AssistantWeb, :live_view

  @impl true
  def mount _params, _session, socket do
    socket = socket |> assign(:current_page, "1")
    {:ok, socket}
  end

  def handle_event "back", _params, socket do
    socket = socket |> assign(:current_page, "1")
    {:noreply, socket}
  end

  def handle_info params, socket do
    socket = socket
      |> assign(:current_page, "2")
      |> assign(:list, params)
    {:noreply, socket}
  end
end
