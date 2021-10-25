defmodule Assistant.AnystyleQueryProcessor do

  alias Assistant.ZenonService
  alias Assistant.AnystyleAdapter

  def process_query {raw_references, split_references} do

    anystyle_results = AnystyleAdapter.ask_anystyle raw_references

    zenon_results =
      anystyle_results
      |> Enum.map(&to_author/1)
      |> Enum.map(&extract_first_author_family_name/1)
      |> Enum.map(&ZenonService.query_zenon/1)

    Enum.zip [split_references, anystyle_results, zenon_results]
  end

  def to_author item do
    item["author"]
  end

  defp extract_first_author_family_name [author|_] do
    author = if author["family"] do author["family"] else author["given"] end
    # Enum.find item, fn {k,v} -> not is_nil(kend

    if not is_nil(author) and String.contains?(author, ",") do
      String.split(author, ",") |> List.first
    else
      author
    end
  end
  defp extract_first_author_family_name _ do
    nil
  end
end
