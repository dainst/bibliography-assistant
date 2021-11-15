defmodule Assistant.AnystyleCsvBuilder do

  import Assistant.AnystyleHelper

  def generate list do
    entries = Enum.map list, fn [given, entry, _] ->
      "\"#{extract_given_name(entry) |> escape}\"," <>
      "\"#{extract_family_name(entry) |> escape}\"," <>
      "\"#{extract_title(entry) |> escape}\"," <>
      "\"#{extract_date(entry) |> escape}\"," <>
      "\"#{extract_doi(entry) |> escape}\"," <>
      "\"#{extract_type(entry) |> escape}\"," <>
      "\"#{extract_container_title(entry) |> escape}\"," <>
      "\"#{extract_volume(entry) |> escape}\"," <>
      "\"#{extract_pages(entry) |> escape}\"," <>
      "\"#{given |> escape}\"\n"
    end
    "\"given-name\",\"family-name\",\"title\",\"date\",\"doi\",\"type\",\"container-title\",\"volume\",\"pages\",\"original\"\n#{entries}"
  end

  defp escape entry do
    String.replace entry, "\"", "\"\""
  end
end
