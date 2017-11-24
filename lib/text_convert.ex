defmodule TextConvert do
@doc """
`tree`RSSTreeから文字列に変換する

TextConvert.execute()

"""
  def toString(x)
    when(is_list(x)) do
      List.to_string(x)
    end
  def toString(x) do
    x
  end

  def execute(tree) do
    TextConvert.execute_aux(tree)
    |> List.flatten
    |> (&(Enum.join(&1, "\n"))).()
    |> (&(&1<>"\n")).()
  end

  def execute_aux(tree) do
    Convert.execute(tree,
                fn x -> ["title:" <> (x |> toString)] |> List.flatten end,
                fn x -> ["link:" <> (x |> toString)] |> List.flatten end,
                fn x -> ["description:" <> (x |> toString)] |> List.flatten end,
                fn x -> ["lastBuildDate:" <> (x |> toString)] |> List.flatten end,
                fn x -> ["docs:" <> (x |> toString)] |> List.flatten end,
                fn x -> ["generator:" <> (x |> toString)] |> List.flatten end,
                fn x -> ["pubDate:" <> (x |> toString)] |> List.flatten end,
                fn x -> ["guid:" <> (x |> toString)] |> List.flatten end,
                fn x -> ["enclosure:" <> (x |> toString)] |> List.flatten end,
                fn x -> ["item:" <> (TextConvert.execute_aux(x) |> (&(Enum.join(&1, "\n"))).() |> toString)] |> List.flatten end)
    |> List.flatten
  end

end
