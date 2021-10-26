defmodule Assistant.ZenonService do

  def query_zenon(author) when is_nil(author) do
    {"", []}
  end

  def query_zenon author do
    if String.match?(author, ~r/^[A-Za-z]*$/) do

      zenon_url = Application.fetch_env!(:assistant, :zenon_url)

      with {:ok, results} <- HTTPoison.get "#{zenon_url}/api/v1/search?lookfor=author:#{author}", %{}, [] do
        results = Poison.decode! results.body
        {author, results["records"]}
      else
        {:error, error} ->
          IO.puts "Zenon Service not reachable"
          IO.inspect error
          {"", []}
      end
    else
      {"", []}
    end
  end

  def query_with_suffix suffix do

    zenon_url = Application.fetch_env!(:assistant, :zenon_url)
    suffix = :http_uri.encode suffix

    with {:ok, results} <- HTTPoison.get "#{zenon_url}/api/v1/search?lookfor=#{suffix}", %{}, [] do
      results = Poison.decode! results.body

      if is_nil(results["records"]) do
        {"", []}
      else
        {suffix, results["records"]}
      end
    else
      {:error, error} ->
        IO.puts "Zenon Service not reachable"
        IO.inspect error
        {"", []}
    end
  end
end
