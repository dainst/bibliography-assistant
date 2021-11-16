defmodule Assistant.AnystyleHelper do

  def convert_item item do
    %{
      "given-name": extract_given_name(item),
      "family-name": extract_family_name(item),
      title: extract_title(item)
    }
  end

  def extract_type entry do
    case entry["type"] do
      nil -> ""
      some -> some
    end
  end

  def extract_first entry, key do
    case entry[key] do
      [first|_] -> first
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
