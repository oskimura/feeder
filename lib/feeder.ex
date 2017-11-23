defmodule Feeder do
@moduledoc """
urlからRSSFeed取得し、出力します。
"""
  require Record
  Record.defrecord :xmlElement, Record.extract(:xmlElement, from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlAttribute, Record.extract(:xmlAttribute, from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlText, Record.extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl")

@doc """
  `url`に指定されたサイトを読み込む
## Examples

  Feeder.parseXml(@xml01)

"""
  def getRssFeedXml(url) do
    HTTPoison.get!(url)
    |> getBody
    |> parseXml
  end

@doc """
httpレスポンス`response`がbodyを取得する

"""
  def getBody(response) do
    response.body
  end

@doc """
http `body`からXMLを解析する

"""
  def parseXml(body) do
    {document,_} = body
    |> :binary.bin_to_list
    |> :xmerl_scan.string
    document
  end

@doc """
`body`のxmlを変換しxmerl形式に変換します。

"""
  def xmlToXmerl(body) do
    :xmerl_xpath.string('channel',body)
  end

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
      end

      ))
    end)
  end

@doc """
xmerlのtext valueを取得する

"""
  def getTextValue(tree, tag) do
    tree
    |> Enum.map(&(xmlElement(&1, :content)))
    |> Enum.map(fn elems ->
      elems
      |> Enum.filter(&(xmlElement(&1, :name) in [tag]))
      |> Enum.map(&(xmlElement(&1, :content)))
      |> Enum.map(fn elems ->
        elems
        |> Enum.map(&(xmlText(&1, :value)))
        end)
    end)
    |> List.flatten
  end

@doc """
`tree`RSSTreeから文字列に変換する

"""
  def toString(tree) do
    tree
    |> Enum.map(fn node ->
      case node do
        {:title, title} -> ["title:",  title]
        {:link, link} -> ["link:", link]
        {:description, description} -> ["description:", description]
        {:lastBuildDate, lastBuildDate} -> ["lastBuildDate:", lastBuildDate]
        {:docs, docs} -> ["docs:", docs]
        {:generator, generator} -> ["generator:", generator]
        {:pubDate, pubDate} -> ["pubDate:", pubDate]
        {:guid, guid} -> ["guid:", guid]
        {:enclosure, enclosure} -> ["enclosure:", enclosure]
        {:item, item} -> ["item:", toString(item)]
        _ -> ""
      end
    end)
    |> List.flatten
  end

  def main(args) do
    Feeder.getRssFeedXml("http://tech.uzabase.com/rss")
    |> Feeder.xmlToXmerl
    |> Feeder.parse
    |> List.flatten
    |> Feeder.toString
    |> IO.puts
  end
end
