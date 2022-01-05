defmodule Assistant.Grobid.Adapter do

  alias Assistant.Grobid.Helper

  def ask_grobid input_strings do
    # grobid seems to support sending multiple citations at once, so one could adjust the code here to handle it that way
    results = Enum.map input_strings, &query/1
    unless Enum.find results, &(&1 == {:error, :connection_refused}) do
      results = Enum.map results, fn item -> {item, Helper.convert_item item} end

      {:ok, results}
    else
      {:error, :connection_refused}
    end
  end

  def query input_string do
    url = Application.fetch_env! :assistant, :grobid_path
    headers = [{"Content-Type", "multipart/form-data"}, {"Accept", "application/x-bibtex"}]
    body = {:form, [citations: "#{input_string}"]}
    case HTTPoison.post "#{url}/api/processCitation", body, headers do
      {:ok, results} -> List.first Bibtex.Parser.parse results.body
      error ->
        IO.inspect error
        {:error, :connection_refused}
    end
  end
end
