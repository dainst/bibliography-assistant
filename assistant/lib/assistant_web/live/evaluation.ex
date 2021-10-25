defmodule AssistantWeb.Evaluation do
  use AssistantWeb, :live_component

  alias AssistantWeb.ParserResultListComponent
  alias AssistantWeb.ZenonResultListComponent

  def mount socket do
    {:ok, assign(socket, :selected_item, -1)}
  end

  def handle_event "select", %{ "idx" => idx }, socket do
    {idx, _} = Integer.parse idx
    {:noreply, assign(socket, :selected_item, idx)}
  end
end
