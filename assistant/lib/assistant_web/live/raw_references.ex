defmodule AssistantWeb.RawReferences do
  use AssistantWeb, :live_component

  def handle_event "save", %{ "raw_references" => %{ "raw_references" => raw_references } }, socket do

    send self(), String.split(raw_references, ["\n", "\r", "\r\n"])
    {:noreply, socket}
  end
end
