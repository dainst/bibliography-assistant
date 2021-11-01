defmodule Assistant.Translator do

  @dictionary %{
    bibliographic_references: %{
      en: "Bibliographic references",
      de: "Bibliographische Referenzen"
    },
    one_item_per_line: %{
      en: "One item per line",
      de: "Ein Eintrag pro Zeile"
    },
    evaluate_with_anystyle: %{
      en: "Evaluate with Anystyle",
      de: "Mit Anystyle auswerten"
    },
    generate_download_link: %{
      en: "Generate download link",
      de: "Download Link erzeugen"
    },
    download: %{
      en: "Download",
      de: "Herunterladen"
    },
    new_search: %{
      en: "New search",
      de: "Neue Suche"
    }
  }

  def translate term, lang do
    lang = String.to_atom lang
    @dictionary[term][lang]
  end
end
