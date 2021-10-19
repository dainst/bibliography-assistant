defmodule AssistantWeb.RawReferences do
  use AssistantWeb, :live_component

  alias Assistant.AnystyleQueryProcessor

  def handle_event "save", %{ "raw_references" => %{ "raw_references" => raw_references } }, socket do

    send self(), AnystyleQueryProcessor.process_query raw_references
    {:noreply, socket}
  end
end
