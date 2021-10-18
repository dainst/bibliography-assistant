defmodule AssistantWeb.RawReferences do
  use AssistantWeb, :live_component

  def handle_event "save", %{ "raw_references" => %{ "raw_references" => raw_references } }, socket do

    anystyle_results = Assistant.AnystyleAdapter.ask_anystyle raw_references
    split_references = String.split(raw_references, ["\n", "\r", "\r\n"])

    zipped = Enum.zip split_references, anystyle_results

    send self(), zipped
    {:noreply, socket}
  end
end
