defmodule Assistant.Dispatch do

  alias Assistant.GrobidQueryProcessor
  alias Assistant.CermineQueryProcessor
  alias Assistant.AnystyleQueryProcessor

  # TODO split string before passing to processor; when using api, pass lines as list

  def query "anystyle", raw_references do
    raw_references
    |> AnystyleQueryProcessor.process_query
    |> Enum.map(fn {x,y,z} -> [x,y,z] end)
  end

  def query "grobid", raw_references do
    raw_references
    |> GrobidQueryProcessor.process_query
    |> Enum.map(fn {x,y,z} -> [x,y,z] end)
  end

  def query "cermine", raw_references do
    raw_references
    |> CermineQueryProcessor.process_query
    |> Enum.map(fn {x,y,z} -> [x,y,z] end)
  end
end
