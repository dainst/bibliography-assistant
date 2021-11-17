defmodule AssistantWeb.NavbarComponent do
  use AssistantWeb, :live_component

  alias Assistant.Translator
  alias AssistantWeb.ZenonResultListComponent

  @zenon_url "https://zenon.dainst.org"

  def get_zenon_search_link list do # TODO refactor
    results = get_zenon_results list
    results = Enum.join(results, "+OR+")
    "#{@zenon_url}/Search/Results?lookfor=#{results}&type=SystemNo"
  end

  def has_zenon_results list do
    0 < length get_zenon_results list
  end

  def get_zenon_results list do
    results = Enum.map list,
      fn [_raw, _parsed, {_suffixes, {_num_total_results, _results, selected_result}}] ->
        selected_result
      end

    results = Enum.filter results, fn result -> not is_nil(result) end
    Enum.map results, fn result -> "\"#{result["id"]}\"" end
  end

  def get_suffixes state do
    [_raw, _item, {{api_suffix, ui_suffix}, _}]
      = Enum.at(state.list, state.selected_item)
    {api_suffix, ui_suffix}
  end
end
