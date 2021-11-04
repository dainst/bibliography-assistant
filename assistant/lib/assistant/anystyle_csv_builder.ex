defmodule Assistant.AnystyleCsvBuilder do

  alias Assistant.AnystyleHelper

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

  def extract_primary_title(entry), do: List.first entry["title"]

  def extract_primary_author(nil), do: ""

  def extract_primary_author(""), do: ""

  def extract_primary_author_given_name entry do
    case AnystyleHelper.extract_primary_author entry do
      {family, given} -> given
      _ -> ""
    end
  end

  def extract_primary_author_family_name entry do
    case AnystyleHelper.extract_primary_author entry do
      {family, given} -> family
      _ -> ""
    end
  end
end
