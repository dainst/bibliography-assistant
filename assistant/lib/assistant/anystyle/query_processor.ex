defmodule Assistant.Anystyle.QueryProcessor do

  alias Assistant.Anystyle.Helper
  alias Assistant.Anystyle.Adapter, as: AnystyleAdapter
  alias Assistant.ZenonQueryProcessor

  @doc """
  Returns {:error, reason}, that is, the first error of possibly multiple, if any occurs
  """
  def process_query {raw_references, split_references} do

    with raw_references when raw_references != "" <- raw_references,
         {:ok, results} <- AnystyleAdapter.ask_anystyle(raw_references),
         anystyle_results <- Enum.map(results, &take_fields/1),
         zenon_results <- ZenonQueryProcessor.query_zenon(&extract_author_and_title/1, anystyle_results),
         nil <- ZenonQueryProcessor.get_zenon_error(zenon_results) do

      Enum.zip [split_references, anystyle_results, zenon_results]
    else
      "" -> {:error, :no_input}
      error -> error
    end
  end

  defp take_fields parser_result do
    parser_result
    |> Enum.into(%{})
  end

  defp extract_author_and_title result do

    author = Helper.extract_author result
    title = if not is_nil(result["title"]) and length(result["title"]) > 0 do
      List.first(result["title"])
    end
    {author, title}
  end
end
