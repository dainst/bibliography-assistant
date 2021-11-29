defmodule Assistant.ZenonQueryProcessor do

  import Assistant.ZenonService

  def query_zenon extract_author_and_title, parser_results do
    parser_results
    |> Enum.reduce_while([], query_zenon_reducer(extract_author_and_title))
    |> Enum.reverse
  end

  defp query_zenon_reducer extract_author_and_title do
    fn parser_result, results ->
      case try_queries convert extract_author_and_title.(parser_result) do
        {:error, _reason} = error -> {:halt, [error|results]}
        result -> {:cont, [result|results]}
      end
    end
  end

  def get_zenon_error zenon_results do
    Enum.find(zenon_results, &(match? {:error, _}, &1))
  end

  defp try_queries {author_simple, author_complex, title} do

    shortened_title = shorten title

    with {_, {0, []}} <- query_zenon_with_author_and_title(author_complex, title),
         {_, {0, []}} <- query_zenon_with_author_and_title(author_complex, shortened_title),
         {_, {0, []}} <- query_zenon_with_author_and_title(author_simple, title),
         {_, {0, []}} <- query_zenon_with_author_and_title(author_simple, shortened_title),
         {_, {0, []}} <- query_zenon_with_author_and_title(author_complex, ""),
         {_, {0, []}} = noresult <- query_zenon_with_author_and_title(author_simple, "")
    do
      noresult
    else
      result -> result
    end
  end

  defp shorten nil do
    ""
  end

  defp shorten str do
    str
    |> String.split(~r/[:.,]/)
    |> List.first
  end

  defp convert {author, title} do
    {simple_name(author) || "", complex_name(author) || "", title || ""}
  end

  defp complex_name author do
    case author do
      {family, given} -> "#{remove_dots(given)}.#{family}"
      _ -> author
    end
  end

  defp simple_name author do
    case author do
      {family, _given} -> family
      _ -> author
    end
  end

  defp remove_dots str do
    String.replace(str, ".", "")
  end
end
