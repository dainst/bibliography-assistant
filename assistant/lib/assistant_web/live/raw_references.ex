defmodule AssistantWeb.RawReferences do
  use AssistantWeb, :live_component

  alias Assistant.AnystyleQueryProcessor
  alias Assistant.GrobidQueryProcessor
  alias Assistant.CermineQueryProcessor

  def handle_event "change", %{ "raw_references" => %{ "raw_references" => raw_references } } = params, socket do
    {:noreply, socket |> assign(:raw_references, raw_references)}
  end

  def handle_event "eval", %{ "target" => target }, socket do

    raw_references = socket.assigns.raw_references

    result = case target do
      "grobid" -> {:grobid, GrobidQueryProcessor.process_query(raw_references)}
      "cermine" -> {:cermine, CermineQueryProcessor.process_query(raw_references)}
      "anystyle" -> {:anystyle, AnystyleQueryProcessor.process_query(raw_references)}
      _ -> nil
    end

    send self(), result
    {:noreply, socket}
  end
end
