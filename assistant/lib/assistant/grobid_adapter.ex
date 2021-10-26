defmodule Assistant.GrobidAdapter do

  # curl -X POST -d "citations=Förtsch 2001:
  # R. Försch, Kunstverwendung und Kunstlegitimation im archaischen und
  # frühklassischen Sparta (Mainz am Rhein 2001)." localhost:8070/api/processCitation

  def ask_grobid input_strings do
    Enum.map(input_strings, &query/1)
  end

  def query input_string do
    url = Application.fetch_env! :assistant, :grobid_path
    headers = [{"Content-Type", "multipart/form-data"}, {"Accept", "application/x-bibtex"}]
    body = {:form, [citations: "#{input_string}"]}
    {:ok, results} = HTTPoison.post "#{url}/api/processCitation", body, headers
    List.first Bibtex.Parser.parse results.body
  end
end
