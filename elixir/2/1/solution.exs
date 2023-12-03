defmodule Bag do
  defstruct red: 0, green: 0, blue: 0

  def parse(str) do
    String.split(str, ",")
    |> Enum.map(&String.trim/1)
    |> Enum.reduce(%Bag{}, fn t, s ->
      cond do
        String.ends_with?(t, "red") ->
          %Bag{red: String.to_integer(String.slice(t, 0..-5)), green: s.green, blue: s.blue}

        String.ends_with?(t, "green") ->
          %Bag{red: s.red, green: String.to_integer(String.slice(t, 0..-7)), blue: s.blue}

        String.ends_with?(t, "blue") ->
          %Bag{red: s.red, green: s.green, blue: String.to_integer(String.slice(t, 0..-6))}
      end
    end)
  end
end

defmodule Solution do
  defp possible?(%Bag{red: r, green: g, blue: b}) do
    r <= 12 and g <= 13 and b <= 14
  end

  def get_game_score("Game " <> rest) do
    [index, sets] = String.split(rest, ":")

    p =
      String.split(sets, ";")
      |> Enum.map(&Bag.parse/1)
      |> Enum.all?(&possible?/1)

    (p && String.to_integer(index)) || 0
  end
end

IO.puts(
  IO.read(:stdio, :eof)
  |> String.split("\n")
  |> Enum.filter(&(&1 != ""))
  |> Enum.map(fn game -> Solution.get_game_score(game) end)
  |> Enum.sum()
)
