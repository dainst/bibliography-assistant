defmodule Assistant.AnystyleCsvBuilder do

  import Assistant.AnystyleHelper

  def generate list do
    entries = Enum.map list, fn [given, entry, _] ->
      "\"#{extract_given_name(entry) |> escape}\"," <>
      "\"#{extract_family_name(entry) |> escape}\"," <>
      "\"#{extract_first(entry, "title") |> escape}\"," <>
      "\"#{extract_first(entry, "date") |> escape}\"," <>
      "\"#{extract_first(entry, "doi") |> escape}\"," <>
      "\"#{extract_type(entry) |> escape}\"," <>
      "\"#{extract_first(entry, "container-title") |> escape}\"," <>
      "\"#{extract_first(entry, "volume") |> escape}\"," <>
      "\"#{extract_first(entry, "pages") |> escape}\"," <>
      "\"#{given |> escape}\"\n"
    end
    "\"given-name\",\"family-name\",\"title\",\"date\",\"doi\",\"type\",\"container-title\",\"volume\",\"pages\",\"original\"\n#{entries}"
  end

  defp escape entry do
    String.replace entry, "\"", "\"\""
  end
end
