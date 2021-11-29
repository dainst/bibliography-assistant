defmodule Assistant.Grobid.Adapter do

  # curl -X POST -d "citations=Förtsch 2001:
  # R. Försch, Kunstverwendung und Kunstlegitimation im archaischen und
  # frühklassischen Sparta (Mainz am Rhein 2001)." localhost:8070/api/processCitation

  # TODO maybe do one instead multiple queries

  def ask_grobid input_strings do
    results = Enum.map input_strings, &query/1
    unless Enum.find results, &(&1 == {:error, :connection_refused}) do
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
