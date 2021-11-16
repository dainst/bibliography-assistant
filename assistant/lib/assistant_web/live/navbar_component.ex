defmodule AssistantWeb.NavbarComponent do
  use AssistantWeb, :live_component

  alias Assistant.Translator
  alias AssistantWeb.ZenonResultListComponent

  @zenon_url "https://zenon.dainst.org"

  def get_zenon_search_link list do # TODO refactor

    results = Enum.map list, fn [_raw, _parsed, {_suffixes, {_num_total_results, results, _}}] -> results end
    results = Enum.filter results, fn results -> length(results) == 1 end
    results = Enum.map results, fn results -> "\"#{List.first(results)["id"]}\"" end

    results = Enum.join(results, "+OR+")

    "#{@zenon_url}/Search/Results?lookfor=#{results}&type=SystemNo"
  end

  def get_suffixes state do
    [_raw, _item, {{api_suffix, ui_suffix}, _}]
      = Enum.at(state.list, state.selected_item)
    {api_suffix, ui_suffix}
  end
end
