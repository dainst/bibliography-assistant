defmodule Assistant.AnystyleHelper do

  def convert_item item do
    %{
      "given-name": extract_given_name(item),
      "family-name": extract_family_name(item),
      title: extract_title(item)
    }
  end

  def extract_title(entry), do: List.first entry["title"]

  def extract_date entry do
    case entry["date"] do
      [date|_] -> date
      _ -> ""
    end
  end

  def extract_type entry do
    case entry["type"] do
      nil -> ""
      some -> some
    end
  end

  def extract_container_title entry do
    case entry["container-title"] do
      [container_title|_] -> container_title
      _ -> ""
    end
  end

  def extract_volume entry do
    case entry["volume"] do
      [volume|_] -> volume
      _ -> ""
    end
  end

  def extract_pages entry do
    case entry["pages"] do
      [pages|_] -> pages
      _ -> ""
    end
  end

  def extract_doi entry do
    case entry["doi"] do
      [date|_] -> date
      _ -> ""
    end
  end

  def extract_given_name entry do
    case extract_author entry do
      {_family, given} -> given
      _ -> ""
    end
  end

  def extract_family_name entry do
    case extract_author entry do
      {family, _given} -> family
      _ -> ""
    end
  end

  def extract_author entry do
    case entry["author"] do
      [%{"family" => family, "given" => given}|_] -> {family, given}
      _ -> nil
    end
  end
end
