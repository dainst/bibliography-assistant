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
        |> String.split(":")
        |> List.first
      end

    suffix = case {author, title} do
      {author, ""} -> "author:#{author}"
      {author, nil} -> "author:#{author}"
      {"", title} -> "title:#{title}"
      {nil, title} -> "title:#{title}"
      {author, title} -> "author:#{author} and title:#{title}"
      _ -> nil
    end

    if suffix do
      ZenonService.query_with_suffix suffix
    else
      ["", []]
    end
  end
end
