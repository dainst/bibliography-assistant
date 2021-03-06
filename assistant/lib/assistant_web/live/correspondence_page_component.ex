defmodule AssistantWeb.CorrespondencePageComponent do
  use AssistantWeb, :live_component

  alias Assistant.Translator
  alias AssistantWeb.AnystyleResultComponent
  alias AssistantWeb.GrobidResultComponent

  def mount socket do
    {:ok, socket}
  end
end
