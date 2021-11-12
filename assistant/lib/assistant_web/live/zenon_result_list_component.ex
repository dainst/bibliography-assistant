defmodule AssistantWeb.ZenonResultListComponent do
  use AssistantWeb, :live_component

  alias AssistantWeb.ZenonResultComponent

  @zenon_url "https://zenon.dainst.org"

  def api_link api_suffix do
    "#{@zenon_url}/api/v1/search?lookfor=#{api_suffix}"
  end

  def ui_link ui_suffix do
    "#{@zenon_url}/Search/Results?join=AND&#{ui_suffix}"
  end
end
