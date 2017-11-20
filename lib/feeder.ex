defmodule Feeder do

  # urlに指定されたサイトを読み込む
  def getRssFeedXml(url) do
    url = "http://tech.uzabase.com/rss"
    HTTPoison.get!(url)
  end

  # httpレスポンスがbodyを取得する
  def getBody(response) do
    response.body
  end
end
