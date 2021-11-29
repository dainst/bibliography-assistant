defmodule Assistant.Anystyle.CsvBuilder do

  import Assistant.CsvBuilderHelper
  import Assistant.Anystyle.Helper

  def generate list do
    entries = Enum.map list, fn [given, {_, entry}, zenon] ->
      "\"#{entry[:"given-name"] |> escape}\"," <>
      "\"#{entry[:"family-name"] |> escape}\"," <>
      "\"#{entry[:title] |> escape}\"," <>
      "\"#{entry[:date] |> escape}\"," <>
      "\"#{entry[:doi] |> escape}\"," <>
      "\"#{entry[:type] |> escape}\"," <>
      "\"#{entry[:"container-title"] |> escape}\"," <>
      "\"#{entry[:volume] |> escape}\"," <>
      "\"#{entry[:pages] |> escape}\"," <>
      "\"#{extract_zenon_id(zenon)}\"," <>
      "\"#{extract_zenon_url(zenon)}\"," <>
      "\"#{given |> escape}\"\n"
    end
    "\"given-name\",\"family-name\",\"title\",\"date\",\"doi\",\"type\",\"container-title\",\"volume\",\"pages\",\"zenon-id\",\"zenon-url\",\"original\"\n#{entries}"
  end
end
