defmodule Assistant.AnystyleHelper do

  def extract_primary_author item do
    case item["author"] do
      [%{"family" => family, "given" => given}|_] -> {family, given}
      _ -> nil
    end
  end
end
