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

  test "RSSTree.parse empty xml test" do
    result =
    ImportRSS.parseXml(@xml01)
    |> ImportRSS.xmlToXmerl
    |> RSSTree.parse
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
title:
link:
description:
lastBuildDate:
docs:
generator:
item:
"""

  test "TextConvert.execute  empty xml test" do
    result =
    ImportRSS.parseXml(@xml01)
    |> ImportRSS.xmlToXmerl
    |> RSSTree.parse
    |> List.flatten
    |> TextConvert.execute

    assert result == @result01
  end

  @xml03 """
  <?xml version="1.0"?>
  <rss version="2.0">
    <channel>
      <title>NewsPicks</title>
      <link></link>
      <description>NewsPicks</description>
      <lastBuildDate></lastBuildDate>
      <docs>NewsPicks</docs>
      <generator></generator>
      <item>
        <title>NewsPicks</title>
        <link></link>
        <description>NewsPicks</description>
        <lastBuildDate></lastBuildDate>
        <docs>NewsPicks</docs>
        <generator></generator>
      </item>
    </channel>
  </rss>
  """

  @result02 """
title:
link:
description:
lastBuildDate:
docs:
generator:
item:title:
link:
description:
lastBuildDate:
docs:
generator:
"""
  test "ExcludeNewsPicks exclude test01" do
    result =
    ImportRSS.parseXml(@xml03)
    |> ImportRSS.xmlToXmerl
    |> RSSTree.parse
    |> List.flatten
    |> ExcludeNewsPicks.execute
    |> TextConvert.execute

    assert result == @result02
  end



  @xml04 """
  <?xml version="1.0"?>
  <rss version="2.0">
    <channel>
      <title>aaa</title>
      <link></link>
      <description>bbb</description>
      <lastBuildDate></lastBuildDate>
      <docs>ccc</docs>
      <generator></generator>
      <item>
        <title>ddd</title>
        <link></link>
        <description>eee</description>
        <lastBuildDate></lastBuildDate>
        <docs>fff</docs>
        <generator></generator>
      </item>
    </channel>
  </rss>
  """
@result03 """
title:aaa
link:
description:bbb
lastBuildDate:
docs:ccc
generator:
item:title:ddd
link:
description:eee
lastBuildDate:
docs:fff
generator:
"""
  test "xml ExcludeNewsPicks Not exclude test" do
    result =
    ImportRSS.parseXml(@xml04)
    |> ImportRSS.xmlToXmerl
    |> RSSTree.parse
    |> List.flatten
    |> ExcludeNewsPicks.execute
    |> TextConvert.execute

    assert result == @result03
  end

end
