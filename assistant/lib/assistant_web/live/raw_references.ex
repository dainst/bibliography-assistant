defmodule AssistantWeb.RawReferences do
  use AssistantWeb, :live_component

  alias Assistant.QueryProcessor

  def handle_event "save", %{ "raw_references" => %{ "raw_references" => raw_references } }, socket do

    send self(), QueryProcessor.process_query raw_references
    {:noreply, socket}
  end
end
