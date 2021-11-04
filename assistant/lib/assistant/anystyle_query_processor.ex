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

    anystyle_results =
      raw_references
      |> AnystyleAdapter.ask_anystyle
      |> Enum.map(&take_fields/1)

    zenon_results =
      anystyle_results
      |> Enum.map(&query_zenon/1)

    errors = Enum.filter zenon_results, &(match? {:error, _}, &1)

    case errors do
      [] -> Enum.zip [split_references, anystyle_results, zenon_results]
      [error|_] -> error
    end
  end

  def query_zenon result do

    QueryProcessor.try_queries extract_author_and_title result
  end

  defp take_fields anystyle_result do
    anystyle_result
    |> Enum.filter(fn {k, _} -> k in @fields_to_take end)
    |> Enum.into(%{})
  end

  defp extract_author_and_title result do

    author = AnystyleHelper.extract_primary_author result
    title = if not is_nil(result["title"]) and length(result["title"]) > 0 do
      List.first(result["title"])
    end
    QueryProcessorHelper.convert author, title
  end
end
