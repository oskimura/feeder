defmodule Convert do

    def doTitle(x) do  {:title, x} end
    def dolink(x) do {:link, x} end
    def doDescription(x) do {:description, x} end
    def doLastBuildDate(x) do  {:lastBuildDate, x} end
    def doDocs(x) do {:docs, x} end
    def doGenerator(x) do {:generator, x} end
    def doPubDate(x) do {:pubDate, x} end
    def doGuid(x) do {:guid, x} end
    def doEnclosure(x) do {:enclosure, x} end
    def doItem(x) do  {:item, Convert.execute(x)} end

#  def execute(tree) do
  def execute(tree,
            title \\ &doTitle/1,
            link \\ &Convert.dolink/1,
            description \\ &Convert.doDescription/1,
            lastBuildDate \\ &Convert.doLastBuildDate/1,
            docs \\ &Convert.doDocs/1,
            generator \\ &Convert.doGenerator/1,
            pubDate \\ &Convert.doPubDate/1,
            guid \\ &Convert.doGuid/1,
            enclosure \\ &Convert.doEnclosure/1,
            item \\ &Convert.doItem/1) do
    tree
    |> Enum.map(fn node ->
      case node do
        {:title, x} ->  title.(x)
        {:link, x} -> link.(x)
        {:description, x} -> description.(x)
        {:lastBuildDate, x} -> lastBuildDate.(x)
        {:docs, x} -> docs.(x)
        {:generator, x} -> generator.(x)
        {:pubDate, x} -> pubDate.(x)
        {:guid, x} -> guid.(x)
        {:enclosure, x} -> enclosure.(x)
        {:item, x} -> item.(x)
        _ -> ""
      end
    end)
    |> List.flatten
  end

end
