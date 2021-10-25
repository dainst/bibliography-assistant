defmodule Assistant.GrobidQueryProcessor do

  alias Assistant.ZenonService
  alias Assistant.GrobidAdapter

  def process_query {raw_references, split_references} do

    grobid_results = GrobidAdapter.ask_grobid split_references

    zenon_results =
      grobid_results
      |> Enum.map(&query_zenon/1)

    Enum.zip [split_references, grobid_results, zenon_results]
  end

  def query_zenon result do

    author =
      result[:author]
      |> String.replace(~r/\sand\s/, " ")
      |> String.replace(~r/\sund\s/, " ")
      |> String.replace(~r/[-–,]/, " ")
      |> String.replace(~r/\s[A-Za-z]\s/, "")
      |> String.replace(~r/^[A-Za-z]\s/, "")
      |> String.replace(~r/\s[A-Za-z]$/, "")
      |> String.split("\s")
      |> List.first

    title =
      unless is_nil(result[:title]) do
        result[:title]
        |> String.replace(~r["], "")
      end

    suffix = if author == "" do
      "title:#{title}"
    else
      "author:#{author} and title:#{title}"
    end

    IO.inspect suffix

    ZenonService.query_with_suffix suffix
  end
end
