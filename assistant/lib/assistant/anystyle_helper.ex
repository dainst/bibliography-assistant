defmodule Assistant.AnystyleHelper do

  def extract_primary_title(entry), do: List.first entry["title"]

  def extract_primary_author_given_name entry do
    case extract_primary_author entry do
      {family, given} -> given
      _ -> ""
    end
  end

  def extract_primary_author_family_name entry do
    case extract_primary_author entry do
      {family, given} -> family
      _ -> ""
    end
  end

  def extract_primary_author item do
    case item["author"] do
      [%{"family" => family, "given" => given}|_] -> {family, given}
      _ -> nil
    end
  end
end
