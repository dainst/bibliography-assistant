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
      en: "Evaluate",
      de: "Auswerten"
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
    },
    zenon_unreachable: %{
      en: "The Zenon connection has been interrupted during the request",
      de: "Die Zenon Verbindung wurde während der Anfrage unterbrochen"
    },
    "anystyle_field_given-name": %{
      en: "Given name",
      de: "Vorname"
    },
    "anystyle_field_family-name": %{
      en: "Family name",
      de: "Familienname"
    },
    anystyle_field_title: %{
      en: "Title",
      de: "Titel"
    },
    zenon_result_author: %{
      en: "Primary Author",
      de: "Erstgenannte Autorin/Erstgenannter Autor"
    },
    zenon_result_title: %{
      en: "Title",
      de: "Titel"
    }
  }

  def translate term, lang do
    lang = String.to_atom lang
    @dictionary[term][lang]
  end
end
