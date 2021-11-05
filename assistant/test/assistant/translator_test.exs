defmodule Assistant.TranslatorTest do
  use ExUnit.Case

  alias Assistant.Translator

  test "hi" do
    translation = Translator.translate :download, "en"
    assert translation == "Download"
  end
end
