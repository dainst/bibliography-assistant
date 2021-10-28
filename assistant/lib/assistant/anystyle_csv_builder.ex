defmodule Assistant.AnystyleCsvBuilder do

  alias Assistant.AnystyleHelper

  def generate list do
    entries = Enum.map list, fn [given, entry, _] ->
      "\"#{extract_primary_author(entry)}\",\"#{List.first(entry["title"])}\",\"#{given}\"\n"
    end
    "\"author\",\"title\",\"given\"\n#{entries}"
  end

  def extract_primary_author entry do
    if {family, given} = AnystyleHelper.extract_primary_author entry do
      "#{given}.#{family}"
    else
      ""
    end
  end
end
