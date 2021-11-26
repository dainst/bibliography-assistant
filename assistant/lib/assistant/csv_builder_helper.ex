defmodule Assistant.CsvBuilderHelper do

  def extract_zenon_id({
    {suffix_ui, suffix_api},
    {_, _, %{ "id" => id } = selected_item}}) when not is_nil(selected_item) do

    "ZID-#{id}"
  end

  def extract_zenon_id(_), do: ""

  def extract_zenon_url({
    {suffix_ui, suffix_api},
    {_, _, %{ "id" => id } = selected_item}}) when not is_nil(selected_item) do

    "https://zenon.dainst.org/Record/#{id}"
  end

  def extract_zenon_url(_), do: ""

  def escape entry do
    String.replace entry, "\"", "\"\""
  end
end
