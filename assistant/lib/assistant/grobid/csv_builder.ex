defmodule Assistant.Grobid.CsvBuilder do

  import Assistant.CsvBuilderHelper
  import Assistant.Grobid.Helper

  def generate list do
    entries = Enum.map list, fn [given, entry, zenon] ->
      "\"#{extract(entry, :author) |> escape}\"," <>
      "\"#{extract(entry, :title) |> escape}\"," <>
      "\"#{extract(entry, :year) |> escape}\"," <>
      "\"#{extract(entry, :address) |> escape}\"," <>
      "\"#{extract(entry, :entry_type) |> escape}\"," <>
      "\"#{extract(entry, :journal) |> escape}\"," <>
      "\"#{extract(entry, :pages) |> escape}\"," <>
      "\"#{extract(entry, :volume) |> escape}\"," <>
      "\"#{extract(entry, :editor) |> escape}\"," <>
      "\"#{extract(entry, :booktitle) |> escape}\"," <>
      "\"#{extract(entry, :doi) |> escape}\"," <>
      "\"#{extract_zenon_id(zenon)}\"," <>
      "\"#{extract_zenon_url(zenon)}\"," <>
      "\"#{given |> escape}\"\n"
    end
    "\"author\",\"title\",\"year\",\"address\",\"entry-type\",\"journal\",\"pages\",\"volume\",\"editor\",\"booktitle\",\"doi\",\"zenon-id\",\"zenon-url\",\"original\"\n#{entries}"
  end
end
