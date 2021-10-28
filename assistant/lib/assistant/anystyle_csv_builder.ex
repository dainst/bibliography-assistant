defmodule Assistant.AnystyleCsvBuilder do

  def generate list do
    entries = Enum.map list, fn [_,y,_] ->
      "#{List.first(y["title"])}\n"
    end
    "title\n#{entries}"
  end
end
