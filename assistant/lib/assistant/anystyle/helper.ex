defmodule Assistant.Anystyle.Helper do

  import Assistant.ParserHelper

  def convert_item item do
    %{
      "given-name": (get_second extract_author item),
      "family-name": (get_first extract_author item),
      title: extract_first(item, "title"),
      date: extract_first(item, "date"),
      doi: extract_first(item, "doi"),
      type: extract_type(item),
      "container-title": extract_first(item, "container-title"),
      volume: extract_first(item, "volume"),
      pages: extract_first(item, "pages")
    }
  end

  def extract_type item do
    case item["type"] do
      nil -> ""
      some -> some
    end
  end

  def extract_first item, key do
    case item[key] do
      [first|_] -> first
      _ -> ""
    end
  end

  defp extract_author item do
    case item["author"] do
      [%{"family" => family, "given" => given}|_] -> {family, given}
      _ -> nil
    end
  end
end
