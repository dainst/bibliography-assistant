defmodule AssistantWeb.Evaluation do
  use AssistantWeb, :live_component

  def mount socket do
    {:ok, assign(socket, :selected_item, -1)}
  end

  def handle_event "select", %{ "idx" => idx }, socket do
    {idx, _} = Integer.parse idx
    state = Map.merge(socket.assigns.state, %{ selected_item: idx })
    socket =
      socket
      |> assign(:state, state)
      |> push_event("select", %{ idx: idx })
    {:noreply, socket}
  end
end
