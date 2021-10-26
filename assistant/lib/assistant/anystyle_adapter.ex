defmodule Assistant.AnystyleAdapter do

  def ask_anystyle input_string do

    url = Application.fetch_env! :assistant, :anystyle_path
    {:ok, results} = HTTPoison.post url, input_string, %{}, []
    (Poison.decode! results.body)["results"]
  end
end
