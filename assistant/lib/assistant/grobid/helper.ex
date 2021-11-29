defmodule Assistant.Grobid.Helper do

  def convert_item item do
    item
  end

  def extract item, key do
    if value = item[key] do
      value
    else
      ""
    end
  end
end
