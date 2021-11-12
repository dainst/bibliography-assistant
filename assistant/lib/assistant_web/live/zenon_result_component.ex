defmodule AssistantWeb.ZenonResultComponent do
  use AssistantWeb, :live_component

  alias Assistant.Translator

  def item_url id do
    "https://zenon.dainst.org/Record/#{id}"
  end
end
