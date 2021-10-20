defmodule Assistant.CermineQueryProcessor do

  alias Assistant.ZenonService
  alias Assistant.CermineAdapter

  def process_query raw_references do

    split_references = String.split(raw_references, ["\n", "\r", "\r\n"])
    cermine_results = CermineAdapter.ask_cermine split_references

    zenon_results =
      cermine_results
      |> Enum.map(&to_author/1)
      |> Enum.map(&ZenonService.query_zenon/1)

    zipped = Enum.zip split_references, cermine_results
    zipped = Enum.zip zipped, zenon_results
  end

  def to_author item do
    item[:author]
  end
end
