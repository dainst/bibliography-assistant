defmodule Assistant.GrobidQueryProcessor do

  alias Assistant.ZenonService
  alias Assistant.GrobidAdapter

  def process_query raw_references do

    split_references =
      raw_references
      |> String.split(["\n", "\r", "\r\n"])
      |> Enum.reject(&(&1 == ""))

    grobid_results = GrobidAdapter.ask_grobid split_references

    zenon_results =
      grobid_results
      |> Enum.map(&to_author/1)
      |> Enum.map(&ZenonService.query_zenon/1)

    Enum.zip [split_references, grobid_results, zenon_results]
  end

  def to_author item do
    item[:author]
  end
end