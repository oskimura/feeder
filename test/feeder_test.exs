defmodule FeederTest do
  use ExUnit.Case
  doctest Feeder


@xml01 """
<?xml version="1.0"?>
<rss version="2.0">
  <channel>
    <title></title>
    <link></link>
    <description></description>
    <lastBuildDate></lastBuildDate>
    <docs></docs>
    <generator></generator>
    <item></item>
  </channel>
</rss>
"""

  test "xml test" do
    result =
    Feeder.parseXml(@xml01)
    |> Feeder.xmlToXmerl
    |> Feeder.parse
    |> List.flatten

    assert result ==
      [title: [],
      link: [],
      description: [],
      lastBuildDate: [],
      docs: [],
      generator: [],
      item: []]
  end

@result01 """
title: link: description: lastBuildDate: docs: generator: item:
"""
  test "xml test2" do
    result =
    Feeder.parseXml(@xml01)
    |> Feeder.xmlToXmerl
    |> Feeder.parse
    |> List.flatten
    |> Feeder.toString

    result == @result01
  end
end
