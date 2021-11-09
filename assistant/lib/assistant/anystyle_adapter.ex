defmodule Assistant.AnystyleAdapter do

  def ask_anystyle input_string do

    url = Application.fetch_env! :assistant, :anystyle_path
    case HTTPoison.post url, input_string, %{}, [] do
      {:ok, results} -> {:ok, Poison.decode!(results.body)["results"]}
      error ->
        IO.inspect error
        {:error, :connection_refused}
    end
  end
end
