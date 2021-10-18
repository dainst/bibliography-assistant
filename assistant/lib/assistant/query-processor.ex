defmodule Assistant.QueryProcessor do

  alias Assistant.ZenonService

  def process_query raw_references do

    split_references = String.split(raw_references, ["\n", "\r", "\r\n"])
    anystyle_results = Assistant.AnystyleAdapter.ask_anystyle raw_references

    zenon_results =
      anystyle_results
      |> Enum.map(&to_author/1)
      |> Enum.map(&extract_first_author_family_name/1)
      |> Enum.map(&ZenonService.query_zenon/1)

    zipped = Enum.zip split_references, anystyle_results
    zipped = Enum.zip zipped, zenon_results
  end

  def to_author item do
    item["author"]
  end

  defp extract_first_author_family_name [author|_] do
    if author["family"] do author["family"] else author["given"] end
    # Enum.find item, fn {k,v} -> not is_nil(kend
  end
  defp extraxt_first_author_family_name _ do
    nil
  end
end
