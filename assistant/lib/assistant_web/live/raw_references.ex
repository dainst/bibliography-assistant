defmodule AssistantWeb.RawReferences do
  use AssistantWeb, :live_component

  alias Assistant.Translator

  def handle_event "change", %{ "raw_references" =>
      %{ "raw_references" => raw_references } } = params, socket do

    {:noreply, socket |> assign(:raw_references, raw_references)}
  end

  def handle_event "eval", %{ "target" => target }, socket do

    send self(), {target, socket.assigns.raw_references}
    {:noreply, socket}
  end
end
