defmodule Assistant.Anystyle.Helper do

  def convert_item item do
    %{
      "given-name": extract_given_name(item),
      "family-name": extract_family_name(item),
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

  def extract_given_name item do
    case extract_author item do
      {_family, given} -> given
      _ -> ""
    end
  end

  def extract_family_name item do
    case extract_author item do
      {family, _given} -> family
      _ -> ""
    end
  end

  def extract_author_and_title item do

    author = extract_author item
    title = extract_title item

    {author, title}
  end

  defp extract_title item do
    if not is_nil(item["title"]) and length(item["title"]) > 0 do
      List.first(item["title"])
    end # TODO "" else ?
  end

  defp extract_author item do
    case item["author"] do
      [%{"family" => family, "given" => given}|_] -> {family, given}
      _ -> nil
    end
  end
end
