defmodule Assistant.Grobid.QueryProcessor do

  import String

  alias Assistant.Grobid.Adapter, as: GrobidAdapter
  alias Assistant.ZenonQueryProcessor

  def process_query {_raw_references, split_references} do

    with {:ok, grobid_results} <- GrobidAdapter.ask_grobid(split_references),
        zenon_results <- ZenonQueryProcessor.query_zenon(&extract_author_and_title/1, grobid_results),
        nil <- ZenonQueryProcessor.get_zenon_error(zenon_results) do

      Enum.zip [split_references, grobid_results, zenon_results]
    else
      error -> error
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
      author
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
end
