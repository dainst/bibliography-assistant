defmodule Assistant.AnystyleCsvBuilder do

  import Assistant.AnystyleHelper

  def generate list do
    entries = Enum.map list, fn [given, entry, _] ->
      "\"#{extract_given_name(entry) |> escape}\"," <>
      "\"#{extract_family_name(entry) |> escape}\"," <>
      "\"#{extract_title(entry) |> escape}\"," <>
      "\"#{given |> escape}\"\n"
    end
    "\"given-name\",\"family-name\",\"title\",\"original\"\n#{entries}"
  end

  defp escape entry do
    String.replace entry, "\"", "\"\""
  end
end
