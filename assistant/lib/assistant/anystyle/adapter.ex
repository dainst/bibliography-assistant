defmodule Assistant.Anystyle.Adapter do

  alias Assistant.Anystyle.Helper

  def ask_anystyle input_string do

    url = Application.fetch_env! :assistant, :anystyle_path
    case HTTPoison.post url, input_string, %{}, [] do
      {:ok, results} ->

        results = Poison.decode!(results.body)["results"]
        results = Enum.map results, &take_fields/1
        results = Enum.map results, fn item -> {item, Helper.convert_item item} end

        {:ok, results}
      error ->
        IO.inspect error
        {:error, :connection_refused}
    end
  end

  defp take_fields parser_result do
    parser_result
    |> Enum.into(%{})
  end
end
