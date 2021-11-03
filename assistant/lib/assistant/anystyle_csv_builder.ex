defmodule Assistant.AnystyleCsvBuilder do

  alias Assistant.AnystyleHelper

  def generate list do
    entries = Enum.map list, fn [given, entry, _] ->
      "\"#{extract_primary_author(entry) |> escape}\"," <>
      "\"#{extract_primary_title(entry) |> escape}\"," <>
      "\"#{given |> escape}\"\n"
    end
    "\"primary-author\",\"title\",\"given\"\n#{entries}"
  end

  defp escape entry do
    String.replace entry, "\"", "\"\""
  end

  def extract_primary_title(entry), do: List.first entry["title"]

  def extract_primary_author(nil), do: ""

  def extract_primary_author(""), do: ""

  def extract_primary_author entry do
    case AnystyleHelper.extract_primary_author entry do
      {family, given} -> "#{given}#{family}"
      _ -> ""
    end
  end
end
