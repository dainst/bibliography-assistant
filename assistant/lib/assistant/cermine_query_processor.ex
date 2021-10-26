defmodule Assistant.CermineQueryProcessor do

  alias Assistant.CermineAdapter
  alias Assistant.QueryProcessorHelper
  alias Assistant.QueryProcessor

  def process_query {_, split_references} do

    cermine_results = CermineAdapter.ask_cermine split_references

    zenon_results =
      cermine_results
      |> Enum.map(&query_zenon/1)

    zipped = Enum.zip [split_references, cermine_results, zenon_results]
  end

  def query_zenon result do

    QueryProcessor.try_queries result, extract_author_and_title result
  end

  defp extract_author_and_title result do
    author =
      result[:author]

    num_commas = Kernel.length Regex.scan ~r/,/, author
    num_dots = Kernel.length Regex.scan ~r/\./, author

    author = if num_dots == 1 and String.ends_with?(author, ".") and num_commas == 1 do
      author = String.replace_suffix author, ".", ""
      author = String.replace_suffix author, ",", ""
      [family, given] = String.split(author, ",")
      {family, given}
    end

    title =
      result[:title]

    QueryProcessorHelper.convert author, title
  end
end
