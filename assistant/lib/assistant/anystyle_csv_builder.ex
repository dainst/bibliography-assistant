defmodule Assistant.AnystyleCsvBuilder do

  alias Assistant.AnystyleHelper

  def generate list do
    entries = Enum.map list, fn [given, entry, _] ->
      "\"#{extract_primary_author(entry)}\",\"#{List.first(entry["title"])}\",\"#{given}\"\n"
    end
    "\"author\",\"title\",\"given\"\n#{entries}"
  end

  def extract_primary_author nil do
    ""
  end

  def extract_primary_author "" do
    ""
  end

  def extract_primary_author entry do
    case AnystyleHelper.extract_primary_author entry do
      {family, given} -> "#{given}.#{family}"
      _ -> ""
    end
  end
end
