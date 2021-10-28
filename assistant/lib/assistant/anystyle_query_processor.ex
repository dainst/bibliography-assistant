defmodule Assistant.AnystyleQueryProcessor do

  alias Assistant.AnystyleHelper
  alias Assistant.AnystyleAdapter
  alias Assistant.QueryProcessorHelper
  alias Assistant.QueryProcessor

  def process_query {raw_references, split_references} do

    anystyle_results = AnystyleAdapter.ask_anystyle raw_references

    zenon_results =
      anystyle_results
      |> Enum.map(&query_zenon/1)

    Enum.zip [split_references, anystyle_results, zenon_results]
  end

  def query_zenon result do

    QueryProcessor.try_queries result, extract_author_and_title result
  end

  defp extract_author_and_title result do

    author = AnystyleHelper.extract_primary_author result
    title = if not is_nil(result["title"]) and length(result["title"]) > 0 do
      List.first(result["title"])
    end
    IO.inspect title
    QueryProcessorHelper.convert author, title
  end
end
