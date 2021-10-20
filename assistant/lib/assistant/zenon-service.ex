defmodule Assistant.ZenonService do

  def query_zenon author do

    unless author do
      {nil, 0, []}
    else

      author = if String.contains?(author, ",") do
        String.split(author, ",") |> List.first
      else
        author
      end

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
        {nil, 14, [
          "zenon-result-1:#{author}",
          "zenon-result-2:#{author}",
          "zenon-result-3:#{author}",
          "zenon-result-4:#{author}",
          "zenon-result-5:#{author}",
          "zenon-result-6:#{author}",
          "zenon-result-7:#{author}",
          "zenon-result-8:#{author}",
          "zenon-result-9:#{author}",
          "zenon-result-10:#{author}",
          "zenon-result-11:#{author}",
          "zenon-result-12:#{author}",
          "zenon-result-13:#{author}",
          "zenon-result-14:#{author}"
          ]}
      end
    end
  end
end
