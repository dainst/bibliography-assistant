defmodule Assistant.CermineQueryProcessor do

  alias Assistant.ZenonService
  alias Assistant.CermineAdapter

  def process_query {_, split_references} do

    cermine_results = CermineAdapter.ask_cermine split_references

    zenon_results =
      cermine_results
      |> Enum.map(&to_author/1)
      |> Enum.map(&ZenonService.query_zenon/1)

    zipped = Enum.zip [split_references, cermine_results, zenon_results]
  end

  def to_author item do
    author = item[:author]

    if String.contains?(author, ",") do
      String.split(author, ",") |> List.first
    else
      author
    end
  end
end
