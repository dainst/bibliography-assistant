defmodule Assistant.AnystyleHelper do

  def convert_item item do
    %{
      "given-name": extract_given_name(item),
      "family-name": extract_family_name(item),
      title: extract_title(item)
    }
  end

  def extract_title(entry), do: List.first entry["title"]

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

  def extract_author item do
    case item["author"] do
      [%{"family" => family, "given" => given}|_] -> {family, given}
      _ -> nil
    end
  end
end
