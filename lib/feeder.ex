defmodule Feeder do
@moduledoc """
urlからRSSFeed取得し、出力します。

"""
  require Record
  Record.defrecord :xmlElement, Record.extract(:xmlElement, from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlAttribute, Record.extract(:xmlAttribute, from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlText, Record.extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl")

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

  def main(args) do
    ImportRSS.execute("http://tech.uzabase.com/rss")
    |> RSSTree.parse
    |> List.flatten
    |> ExcludeNewsPicks.execute
    |> TextConvert.execute
    |> IO.puts
  end
end
