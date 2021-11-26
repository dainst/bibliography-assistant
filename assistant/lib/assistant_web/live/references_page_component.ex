defmodule AssistantWeb.ReferencesPageComponent do
  use AssistantWeb, :live_component

  alias Assistant.Translator

  def mount socket do
    {
      :ok,
      socket
      |> assign(:control_pressed, false)
      |> assign(:shift_pressed, false)
    }
  end

  def handle_event "change", %{ "raw_references" =>
      %{ "raw_references" => raw_references } }, socket do

    {:noreply, socket |> assign(:raw_references, raw_references)}
  end

  def handle_event "eval", %{ "target" => target }, socket do

    send self(), {target, socket.assigns[:raw_references] || ""}
    {:noreply, socket}
  end

  def handle_event "keydown", %{ "key" => key }, socket do
    socket = case key do
      "Control" -> assign(socket, :control_pressed, true)
      "Shift" -> assign(socket, :shift_pressed, true)
      _ -> socket
    end
    {:noreply, socket}
  end

  def handle_event "keyup", %{ "key" => key }, socket do
    socket = case key do
      "Control" -> assign(socket, :control_pressed, false)
      "Shift" -> assign(socket, :shift_pressed, false)
      _ -> socket
    end
    {:noreply, socket}
  end
end
