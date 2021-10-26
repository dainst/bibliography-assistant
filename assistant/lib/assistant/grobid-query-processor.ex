defmodule Assistant.GrobidQueryProcessor do

  import String

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

    {author, title} = extract_author_and_title result

    {_, results} = result = query_zenon_with_author_and_title complex_name(author), title
    unless Kernel.length(results) == 0 do
      result
    else
      {_, results} = result = query_zenon_with_author_and_title simple_name(author), title
      unless Kernel.length(results) == 0 do
        result
      else
        {_, results} = result= query_zenon_with_author_and_title complex_name(author), nil
        unless Kernel.length(results) == 0 do
          result
        else
          query_zenon_with_author_and_title simple_name(author), nil
        end
      end
    end
  end

  defp query_zenon_with_author_and_title author, title do
    suffix = if author == "" or author == nil do
      case title do
        nil -> nil
        title -> "title:#{title}"
      end
    else
      case {author, title} do
        {author, ""} -> "author:#{author}"
        {author, nil} -> "author:#{author}"
        {author, title} -> "author:#{author} and title:#{title}"
        _ -> nil
      end
    end

    IO.inspect suffix
    if suffix do
      ZenonService.query_with_suffix suffix
    else
      {"", []}
    end
  end

  defp extract_author_and_title result do
    author =
      result[:author]
      |> split(~r/\sand\s/) # this is grobid's way of separating authors
      |> List.first

    num_commas = Kernel.length Regex.scan ~r/,/, author

    author = if num_commas == 1 do
      author = replace author, "\s", ""
      [family, given] = split author, ","
      {family, given}
    else
      family = author
      |> replace(~r/[-–,]/, " ")
      |> replace(~r/\s[A-Za-z]\s/, "")
      |> replace(~r/^[A-Za-z]\s/, "")
      |> replace(~r/\s[A-Za-z]$/, "")
      |> split("\s")
      |> List.first
    end

    title =
      unless is_nil(result[:title]) do
        result[:title]
        |> String.replace(~r["], "")
        |> String.split(":")
        |> List.first
      end

    {author, title}
  end

  defp complex_name author do
    case author do
      {family, given} -> "#{given}.#{family}"
      _ -> author
    end
  end

  defp simple_name author do
    case author do
      {family, given} -> family
      _ -> author
    end
  end
end
