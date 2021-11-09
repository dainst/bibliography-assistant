defmodule Assistant.GrobidQueryProcessor do

  # import String

  alias Assistant.GrobidAdapter
  # alias Assistant.QueryProcessorHelper
  # alias Assistant.QueryProcessor

  def process_query {_raw_references, split_references} do

    grobid_results = GrobidAdapter.ask_grobid split_references

    zenon_results =
      grobid_results
      |> Enum.map(&query_zenon/1)

    Enum.zip [split_references, grobid_results, zenon_results]
  end

  def query_zenon _result do

    # QueryProcessor.try_queries result, extract_author_and_title result
  end

  # defp extract_author_and_title result do
    # author =
      # result[:author]
      # |> split(~r/\sand\s/) # this is grobid's way of separating authors
      # |> List.first
#
    # num_commas = Kernel.length Regex.scan ~r/,/, author
#
    # author = if num_commas == 1 do
      # author = replace author, "\s", ""
      # [family, given] = split author, ","
      # {family, given}
    # else
      # author
      # |> replace(~r/[-–,]/, " ")
      # |> replace(~r/\s[A-Za-z]\s/, "")
      # |> replace(~r/^[A-Za-z]\s/, "")
      # |> replace(~r/\s[A-Za-z]$/, "")
      # |> split("\s")
      # |> List.first
    # end
#
    # title =
      # unless is_nil(result[:title]) do
        # result[:title]
        # |> String.replace(~r["], "")
        # |> String.split(":")
        # |> List.first
      # end
#
    # QueryProcessorHelper.convert author, title
  # end
end
