defmodule Assistant.ZenonQueryProcessor do

  def query_zenon parser_results do
    parser_results
    |> Enum.map(&prepare_queries_for_parser_result/1)
    |> Enum.reduce_while([], &query_zenon_reducer/2)
    |> Enum.reverse
  end

  defp prepare_queries_for_parser_result {_parser_result, converted_parser_result} do
    converted_parser_result
    |> extract_author_and_title
    |> convert
    |> prepare_queries
  end

  defp query_zenon_reducer queries_for_parser_result, results do
    case try_queries queries_for_parser_result do
      {:error, _reason} = error -> {:halt, [error|results]}
      result -> {:cont, [result|results]}
    end
  end

  def get_zenon_error zenon_results do
    Enum.find(zenon_results, &(match? {:error, _}, &1))
  end

  defp try_queries suffixes do

    Enum.reduce_while suffixes, {{"", ""}, {0, []}}, fn suffix, suffixes ->
      case query_zenon_with_author_and_title suffix do
        {_, {0, []}} -> {:cont, suffixes}
        result -> {:halt, result}
      end
    end
  end

  defp prepare_queries {author_simple, author_complex, title} do
    shortened_title = shorten title
    [
      extract_query_suffixes(author_complex, title),
      extract_query_suffixes(author_complex, shortened_title),
      extract_query_suffixes(author_simple, title),
      extract_query_suffixes(author_simple, shortened_title),
      extract_query_suffixes(author_complex, ""),
      extract_query_suffixes(author_simple, "")
    ]
  end

  defp query_zenon_with_author_and_title suffixes do

    IO.inspect elem(suffixes, 0)
    if suffixes != {"", ""} do
      query_with_suffix suffixes
    else
      {{"", ""}, {0, []}} # TODO necessary?
    end
  end

  defp extract_query_suffixes author, title do
    if author == "" do
      case title do
        nil -> {"", ""}
        title -> {
          "title:#{title}",
          "lookfor0[]=#{title}&type0[]=AllFields"
        }
      end
    else
      case {author, title} do
        {author, ""} -> {
          "author:#{author}",
          "lookfor0[]=#{author}&type0[]=Author"
        }
        {author, title} ->
          t = String.replace(title," ","+")
          {
            "author:#{author} and title:#{title}",
            "lookfor0[]=#{author}&type0[]=Author&lookfor0[]=#{t}&type0[]=AllFields"
          }
      end
    end
  end

  defp query_with_suffix {api_suffix, ui_suffix} do

    zenon_url = Application.fetch_env!(:assistant, :zenon_url)
    suffix = :http_uri.encode api_suffix

    suffixes = {api_suffix, :http_uri.encode(ui_suffix)
      |> String.replace("%3D", "=") |> String.replace("%26","&")}

    with {:ok, results} <- HTTPoison.get "#{zenon_url}/api/v1/search?limit=100&lookfor=#{suffix}", %{}, [] do
      results = Poison.decode! results.body

      if is_nil(results["records"]) do
        {suffixes, {0, []}}
      else
        {suffixes, {results["resultCount"], results["records"]}}
      end
    else
      {:error, error} ->
        IO.puts "Zenon Service not reachable"
        IO.inspect error
        {:error, :zenon_unreachable}
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

  defp extract_author_and_title item do
    {{item[:"family-name"], item[:"given-name"]}, item[:title]}
  end

  defp complex_name author do
    case author do
      {"", ""} -> ""
      {family, given} -> "#{remove_dots(given)}.#{family}"
      _ -> ""
    end
  end

  defp simple_name author do
    case author do
      {"", _} -> ""
      {family, _given} -> family
      _ -> ""
    end
  end

  defp remove_dots str do
    String.replace(str, ".", "")
  end
end
