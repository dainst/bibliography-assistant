defmodule Assistant.AnystyleCsvBuilder do

  import Assistant.AnystyleHelper

  def generate list do
    entries = Enum.map list, fn [given, entry, _] ->
      "\"#{extract_primary_author_given_name(entry) |> escape}\"," <>
      "\"#{extract_primary_author_family_name(entry) |> escape}\"," <>
      "\"#{extract_primary_title(entry) |> escape}\"," <>
      "\"#{given |> escape}\"\n"
    end
    "\"primary-author-given-name\",\"primary-author-family-name\",\"title\",\"given\"\n#{entries}"
  end

  defp escape entry do
    String.replace entry, "\"", "\"\""
  end
end
