defmodule RSSTree do
@moduledoc """
XMLからRSSを表現する中間表現木を作製する

# exmaple
RSSTree.parse()

"""

require Record
Record.defrecord :xmlElement, Record.extract(:xmlElement, from_lib: "xmerl/include/xmerl.hrl")
Record.defrecord :xmlAttribute, Record.extract(:xmlAttribute, from_lib: "xmerl/include/xmerl.hrl")
Record.defrecord :xmlText, Record.extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl")

@doc """
`elem`に指定された要素のtext valueを取得します

"""
  def parseText(elem) do
    xmlElement(elem, :content)
    |> Enum.map(fn elems ->
      xmlText(elems, :value)
    end)
    |> List.flatten
  end

@doc """
要素`elem`に応じたRSSTreeを返す

"""
  def parseItemElement(elem) do
    case xmlElement(elem, :name) do
      :title -> {:title, parseText(elem)}
      :link -> {:link, parseText(elem)}
      :description -> {:description, parseText(elem)}
      :lastBuildDate -> {:lastBuildDate, parseText(elem)}
      :docs -> {:docs, parseText(elem)}
      :generator -> {:generator, parseText(elem)}
      :pubDate -> {:pubData, parseText(elem)}
      :guid -> {:guid, parseText(elem)}
      :enclosure -> {:enclosure, parseText(elem)}
      # :item -> contents = xmlElement(elem, :content)
    end
  end

@doc """
`tree`xmerlを受取ってRssTreeを返す

"""
  def parse(tree) do
    tree
    |> Enum.map(&(xmlElement(&1, :content)))
    |> Enum.map(fn elems ->
      elems
      |> Enum.map(&(
      case xmlElement(&1, :name) do
        :title -> {:title, parseText(&1)}
        :link -> {:link, parseText(&1)}
        :description -> {:description,parseText(&1)}
        :lastBuildDate -> {:lastBuildDate, parseText(&1)}
        :docs -> {:docs, parseText(&1)}
        :generator -> {:generator, parseText(&1)}
        :item -> item = xmlElement(&1, :content)
                  |> Enum.map(fn content->
                    case content do
                      {:xmlText, _, _, _, _, _} ->
                        text = xmlText(content, :value) |> List.flatten
                        {:text, text}
                      {:xmlElement, _, _, _, _, _, _, _, _, _, _ ,_} ->
                        parseItemElement(content)
                    end
                  end)
                  {:item, item}
        els -> []
      end))
    end)
  end
end
