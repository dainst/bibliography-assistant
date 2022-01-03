defmodule Assistant.ZenonQueryProcessor do

  alias Assistant.ZenonQueryHelper

  def query_zenon parser_results do
    parser_results
    |> Enum.map(&ZenonQueryHelper.prepare_queries_for_parser_result/1)
    |> Enum.reduce_while([], &query_zenon_reducer/2)
    |> Enum.reverse
    |> Enum.map(&sort_rezensionen_for_result/1)
  end

  defp sort_rezensionen_for_result {suffixes, {num_results, results}} do
    {suffixes, {num_results, sort_rezensionen(results)}}
  end

  defp sort_rezensionen zenon_results do
    matches = Enum.filter zenon_results, &is_rezension/1
    non_matches = Enum.filter zenon_results, &(!is_rezension &1)
    non_matches ++ matches
  end

  defp is_rezension zenon_result do
    Map.has_key?(zenon_result, "title") and String.match?(zenon_result["title"], ~r/^\[Rez\..*\]/)
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

  defp query_zenon_with_author_and_title suffixes do

    IO.inspect elem(suffixes, 0)
    if suffixes != {"", ""} do
      query_with_suffix suffixes
    else
      {{"", ""}, {0, []}} # TODO necessary?
    end
  end

  defp query_with_suffix {api_suffix, ui_suffix} do

    zenon_url = Application.fetch_env!(:assistant, :zenon_url)
    query_url = "#{zenon_url}/api/v1/search?limit=100&lookfor=#{:http_uri.encode api_suffix}"

    suffixes = {api_suffix, :http_uri.encode(ui_suffix)
      |> String.replace("%3D", "=") |> String.replace("%26","&")}

    with {:ok, results} <- HTTPoison.get query_url, %{}, [] do
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
end
