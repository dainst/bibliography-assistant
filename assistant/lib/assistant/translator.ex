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
    evaluate: %{
      en: "Evaluate",
      de: "Auswerten"
    },
    evaluate_with_anystyle: %{
      en: "Evaluate with Anystyle",
      de: "Auswerten mit Anystyle"
    },
    evaluate_with_grobid: %{
      en: "Evaluate with GROBID",
      de: "Auswerten mit GROBID"
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
    error_no_input: %{
      en: "No input",
      de: "Keine Eingabe"
    },
    error_connection_refused: %{
      en: "Parser not reachable",
      de: "Parser nicht erreichbar"
    },
    error_zenon_unreachable: %{
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
    anystyle_field_date: %{
      en: "Date",
      de: "Datum"
    },
    anystyle_field_doi: %{
      en: "DOI",
      de: "DOI"
    },
    anystyle_field_type: %{
      en: "Type",
      de: "Typ"
    },
    "anystyle_field_container-title": %{
      en: "Container title",
      de: "Titel der Publikation"
    },
    anystyle_field_volume: %{
      en: "Volume",
      de: "Band"
    },
    anystyle_field_pages: %{
      en: "Pages",
      de: "Seiten"
    },
    grobid_field_author: %{
      en: "Primary Author",
      de: "Erstgenannte Autorin/Erstgenannter Autor"
    },
    grobid_field_volume: %{
      en: "Volume",
      de: "Band"
    },
    grobid_field_pages: %{
      en: "Pages",
      de: "Seiten"
    },
    grobid_field_entry_type: %{
      en: "Type",
      de: "Typ"
    },
    grobid_field_journal: %{
      en: "Journal",
      de: "Journal"
    },
    grobid_field_doi: %{
      en: "DOI",
      de: "DOI"
    },
    grobid_field_title: %{
      en: "Title",
      de: "Titel"
    },
    grobid_field_address: %{
      en: "Address",
      de: "Adresse"
    },
    grobid_field_year: %{
      en: "Year",
      de: "Jahr"
    },
    grobid_field_editor: %{
      en: "Editor/in",
      de: "Editor"
    },
    grobid_field_booktitle: %{
      en: "Book title",
      de: "Buchtitel"
    },
    zenon_result_author: %{
      en: "Primary Author",
      de: "Erstgenannte Autorin/Erstgenannter Autor"
    },
    zenon_result_title: %{
      en: "Title",
      de: "Titel"
    },
    no_search_results: %{
      en: "No search results",
      de: "Keine Suchtreffer"
    },
    select_from_search_results: %{
      en: "Select search result",
      de: "Suchtreffer auswählen"
    },
    number_of_results_of_search_for: %{
      en: "Total number of results of zenon search for",
      de: "Gesamtanzahl der Ergebnisse zur Zenon-Suche nach"
    },
    show_results_in_zenon: %{
      de: "Suchergebnisse in Zenon anzeigen",
      en: "Show search results in Zenon"
    }
  }

  def translate term, lang do
    lang = String.to_atom lang
    @dictionary[term][lang]
  end
end
