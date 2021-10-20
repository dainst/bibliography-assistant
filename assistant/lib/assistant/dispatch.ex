defmodule Assistant.Dispatch do

  alias Assistant.GrobidQueryProcessor
  alias Assistant.CermineQueryProcessor
  alias Assistant.AnystyleQueryProcessor

  def query "anystyle", raw_references do
    AnystyleQueryProcessor.process_query raw_references
  end

  def query "grobid", raw_references do
    GrobidQueryProcessor.process_query raw_references
  end

  def query "cermine", raw_references do
    CermineQueryProcessor.process_query raw_references
  end
end
