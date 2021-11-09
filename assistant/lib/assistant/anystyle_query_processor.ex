defmodule Assistant.AnystyleQueryProcessor do

  alias Assistant.AnystyleHelper
  alias Assistant.AnystyleAdapter
  alias Assistant.QueryProcessorHelper
  alias Assistant.QueryProcessor

  @fields_to_take ["author", "title"]

  @doc """
  Returns {:error, reason}, that is, the first error of possibly multiple, if any occurs
  """
  def process_query {raw_references, split_references} do

    with raw_references when raw_references != "" <- raw_references,
         {:ok, results} <- AnystyleAdapter.ask_anystyle(raw_references),
         anystyle_results <- Enum.map(results, &take_fields/1),
         zenon_results <- query_zenon(anystyle_results),
         nil <- get_error(zenon_results) do

      Enum.zip [split_references, anystyle_results, zenon_results]
    else
      "" -> {:error, :no_input}
      error -> error
    end
  end

  def query_zenon anystyle_results do
    anystyle_results
    |> Enum.reduce_while([], &query_zenon_reducer/2)
    |> Enum.reverse
  end

  defp query_zenon_reducer anystyle_result, results do
    case QueryProcessor.try_queries extract_author_and_title anystyle_result do
      {:error, _reason} = error -> {:halt, [error|results]}
      result -> {:cont, [result|results]}
    end
  end

  defp get_error zenon_results do
    Enum.find(zenon_results, &(match? {:error, _}, &1))
  end

  defp take_fields anystyle_result do
    anystyle_result
    |> Enum.filter(fn {k, _} -> k in @fields_to_take end)
    |> Enum.into(%{})
  end

  defp extract_author_and_title result do

    author = AnystyleHelper.extract_author result
    title = if not is_nil(result["title"]) and length(result["title"]) > 0 do
      List.first(result["title"])
    end
    QueryProcessorHelper.convert author, title
  end
end
