defmodule Assistant.CermineAdapter do

  def ask_cermine input_strings do
    Enum.map(input_strings, &query/1)
  end

  def query input_string do
    url = Application.fetch_env! :assistant, :cermine_path
    headers = [{"Content-Type", "multipart/form-data"}, {"Accept", "application/x-bibtex"}]
    body = {:form, [reference: "#{input_string}"]}
    {:ok, results} = HTTPoison.post "#{url}/parse.do", body, headers
    body = String.replace results.body, ",\n}", "}"
    List.first Bibtex.Parser.parse body
  end

  # "@article{Borg,\n\tauthor = {Borg, B.E.},\n\tjournal = {Die antiken Skulpturen in Castle Howard, MAR},\n\tvolume = {51},\n}\n"
end
