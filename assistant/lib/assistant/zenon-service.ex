defmodule Assistant.ZenonService do

  @zenon_url "https://zenon.dainst.org"

  def query_zenon author do
    {:ok, results} = HTTPoison.get "#{@zenon_url}/api/v1/search?lookfor=author:#{author}", %{}, []
    results = Poison.decode! results.body
    {author, results["resultCount"]}
  end
end
