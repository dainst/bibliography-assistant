defmodule Assistant.Grobid.CsvBuilder do

  import Assistant.CsvBuilderHelper
  import Assistant.Grobid.Helper

  def generate list do
    entries = Enum.map list, fn [given, {_, entry}, zenon] ->
      IO.inspect entry
      "\"#{entry[:"given-name"] |> escape}\"," <>
      "\"#{entry[:"family-name"] |> escape}\"," <>
      "\"#{entry[:title] |> escape}\"," <>
      "\"#{entry[:year] |> escape}\"," <>
      "\"#{entry[:address] |> escape}\"," <>
      "\"#{entry[:entry_type] |> escape}\"," <>
      "\"#{entry[:journal] |> escape}\"," <>
      "\"#{entry[:pages] |> escape}\"," <>
      "\"#{entry[:volume] |> escape}\"," <>
      "\"#{entry[:editor] |> escape}\"," <>
      "\"#{entry[:booktitle] |> escape}\"," <>
      "\"#{entry[:doi] |> escape}\"," <>
      "\"#{extract_zenon_id(zenon)}\"," <>
      "\"#{extract_zenon_url(zenon)}\"," <>
      "\"#{given |> escape}\"\n"
    end
    "\"given-name\",\"family-name\",\"title\",\"year\",\"address\",\"entry-type\",\"journal\",\"pages\",\"volume\",\"editor\",\"booktitle\",\"doi\",\"zenon-id\",\"zenon-url\",\"original\"\n#{entries}"
  end
end
