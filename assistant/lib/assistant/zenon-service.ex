defmodule Assistant.ZenonService do

  @zenon_url "https://zenon.dainst.org"

  def query_zenon author do
    with {:ok, results} <- HTTPoison.get "#{@zenon_url}/api/v1/search?lookfor=author:#{author}", %{}, [] do
      results = Poison.decode! results.body
      {author, results["resultCount"]}
    else
      {:error, error} ->
        IO.puts "Zenon Service not reachable"
        IO.inspect error
        {nil, 0}
    end
  end
end
