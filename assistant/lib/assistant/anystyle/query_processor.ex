defmodule Assistant.Anystyle.QueryProcessor do

  alias Assistant.Anystyle.Adapter, as: AnystyleAdapter
  alias Assistant.ZenonQueryProcessor

  @doc """
  Returns {:error, reason}, that is, the first error of possibly multiple, if any occurs
  """
  def process_query {raw_references, split_references} do

    with raw_references when raw_references != "" <- raw_references,
         {:ok, anystyle_results} <- AnystyleAdapter.ask_anystyle(raw_references),
         zenon_results <- ZenonQueryProcessor.query_zenon(anystyle_results),
         nil <- ZenonQueryProcessor.get_zenon_error(zenon_results) do

      Enum.zip [split_references, anystyle_results, zenon_results]
    else
      "" -> {:error, :no_input}
      error -> error
    end
  end
end
