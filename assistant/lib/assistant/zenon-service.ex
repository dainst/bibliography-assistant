defmodule Assistant.ZenonService do

  def query_zenon author do
    if zenon_url = Application.fetch_env!(:assistant, :zenon_url) do
      with {:ok, results} <- HTTPoison.get "#{zenon_url}/api/v1/search?lookfor=author:#{author}", %{}, [] do
        results = Poison.decode! results.body
        # IO.inspect results["records"]
        records = Enum.map results["records"], &(&1["id"])
        {author, results["resultCount"], records}
      else
        {:error, error} ->
          IO.puts "Zenon Service not reachable"
          IO.inspect error
          {nil, 0, []}
      end
    else
      IO.puts "Zenon Service not configured"
      {nil, 0, []}
    end
  end
end
