defmodule Assistant.Grobid.QueryProcessor do

  alias Assistant.Grobid.Adapter, as: GrobidAdapter
  alias Assistant.ZenonQueryProcessor

  def process_query {_raw_references, split_references} do

    with {:ok, grobid_results} <- GrobidAdapter.ask_grobid(split_references),
        zenon_results <- ZenonQueryProcessor.query_zenon(grobid_results),
        nil <- ZenonQueryProcessor.get_zenon_error(zenon_results) do

      Enum.zip [split_references, grobid_results, zenon_results]
    else
      error -> error
    end
  end
end
