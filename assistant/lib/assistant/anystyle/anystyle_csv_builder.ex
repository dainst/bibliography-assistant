defmodule Assistant.Anystyle.CsvBuilder do

  import Assistant.CsvBuilderHelper
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
end
