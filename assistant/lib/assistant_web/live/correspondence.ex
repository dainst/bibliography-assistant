defmodule AssistantWeb.Correspondence do
  use AssistantWeb, :live_component

  alias AssistantWeb.AnystyleResultComponent
  alias AssistantWeb.GrobidResultComponent
  alias AssistantWeb.CermineResultComponent

  def mount socket do
    {:ok, socket}
  end
end
