defmodule ImportRSS do
@doc """
RSSのURLからデータを取得して、データをxemrl形式へと変換します。


ImportRSS.execute(url)

"""

@doc """
  `url`に指定されたサイトを読み込む
## Examples

  ImportRSS.parseXml(@xml01)

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
`url`からxmerl形式へ変換する

"""
  def execute(url) do
    url
    |> getRssFeedXml
    |> xmlToXmerl
  end

end
