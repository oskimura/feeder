defmodule ExcludeNewsPicks do

  def exclude(text) do
    if (is_list(text)) do
      String.replace(List.to_string(text), ~r/NewsPicks/u, "")
    else
      String.replace(text, ~r/NewsPicks/u, "")
    end
  end

  def execute(tree) do
    Convert.execute(tree,
                fn x -> {:title, x |> exclude } end,
                fn x -> {:link, x |> exclude } end,
                fn x -> {:description, x |> exclude } end,
                fn x -> {:lastBuildDate, x |> exclude } end,
                fn x -> {:docs, x |> exclude } end,
                fn x -> {:generator, x |> exclude } end,
                fn x -> {:pubDate, x |> exclude } end,
                fn x -> {:guid, x |> exclude } end,
                fn x -> {:enclosure, x |> exclude } end,
                fn x -> {:item, ExcludeNewsPicks.execute(x) |> Enum.filter(&(&1!=""))  |> List.flatten} end)
  end

end
