defmodule Assistant.Anystyle.CsvBuilder do

  import Assistant.Anystyle.Helper

  def generate list do
    entries = Enum.map list, fn [given, entry, zenon] ->
      "\"#{extract_given_name(entry) |> escape}\"," <>
      "\"#{extract_family_name(entry) |> escape}\"," <>
      "\"#{extract_first(entry, "title") |> escape}\"," <>
      "\"#{extract_first(entry, "date") |> escape}\"," <>
      "\"#{extract_first(entry, "doi") |> escape}\"," <>
      "\"#{extract_type(entry) |> escape}\"," <>
      "\"#{extract_first(entry, "container-title") |> escape}\"," <>
      "\"#{extract_first(entry, "volume") |> escape}\"," <>
      "\"#{extract_first(entry, "pages") |> escape}\"," <>
      "\"#{extract_zenon_id(zenon)}\"," <>
      "\"#{extract_zenon_url(zenon)}\"," <>
      "\"#{given |> escape}\"\n"
    end
    "\"given-name\",\"family-name\",\"title\",\"date\",\"doi\",\"type\",\"container-title\",\"volume\",\"pages\",\"zenon-id\",\"zenon-url\",\"original\"\n#{entries}"
  end

  defp extract_zenon_id({
    {suffix_ui, suffix_api},
    {_, _, %{ "id" => id } = selected_item}}) when not is_nil(selected_item) do

    "ZID-#{id}"
  end

  defp extract_zenon_id(_), do: ""

  defp extract_zenon_url({
    {suffix_ui, suffix_api},
    {_, _, %{ "id" => id } = selected_item}}) when not is_nil(selected_item) do

    "https://zenon.dainst.org/Record/#{id}"
  end

  defp extract_zenon_url(_), do: ""

  defp escape entry do
    String.replace entry, "\"", "\"\""
  end
end