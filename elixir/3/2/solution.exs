defmodule Math do
  def is_digit?(str) do
    str == "0" or
      str == "1" or
      str == "2" or
      str == "3" or
      str == "4" or
      str == "5" or
      str == "6" or
      str == "7" or
      str == "8" or
      str == "9"
  end
end

defmodule State do
  defstruct numbers: [], gears: []

  defmodule Number do
    defstruct x: -1, left_y: 2 ** 64, right_y: 0, value: 0

    def parse(line, x_index, y_index, number \\ %Number{}) do
      cond do
        line == "" ->
          {line, y_index, number}

        not Math.is_digit?(String.first(line)) ->
          {line, y_index, number}

        true ->
          parse(String.slice(line, 1..-1), x_index, y_index + 1, %Number{
            x: x_index,
            left_y: min(number.left_y, y_index),
            right_y: max(number.right_y, y_index),
            value: number.value * 10 + String.to_integer(String.first(line))
          })
      end
    end
  end

  defmodule Gear do
    defstruct x: -1, y: -1

    def parse(line, x_index, y_index) do
      {String.slice(line, 1..-1), y_index + 1, %Gear{x: x_index, y: y_index}}
    end
  end

  defp parse_line({line, x_index}, y_index \\ 0, state \\ %State{}) do
    cond do
      line == "" ->
        state

      Math.is_digit?(String.first(line)) ->
        {line, y_index, number} = Number.parse(line, x_index, y_index)

        parse_line({line, x_index}, y_index, %State{
          numbers: [number | state.numbers],
          gears: state.gears
        })

      String.first(line) == "*" ->
        {line, y_index, gear} = Gear.parse(line, x_index, y_index)

        parse_line({line, x_index}, y_index, %State{
          numbers: state.numbers,
          gears: [gear | state.gears]
        })

      true ->
        parse_line({String.slice(line, 1..-1), x_index}, y_index + 1, state)
    end
  end

  def parse(str) do
    String.split(str, "\n")
    |> Enum.filter(&(&1 != ""))
    |> Enum.with_index()
    |> Enum.map(&parse_line/1)
    |> Enum.reduce(%State{}, fn st, acc ->
      %State{
        numbers: acc.numbers ++ st.numbers,
        gears: acc.gears ++ st.gears
      }
    end)
  end
end

defmodule Solution do
  def solve(state) do
    Enum.reduce(state.gears, 0, fn gear, acc ->
      adjs =
        Enum.filter(state.numbers, fn number ->
          (gear.x == number.x and gear.y == number.left_y - 1) or
            (gear.x == number.x and gear.y == number.right_y + 1) or
            (gear.x == number.x - 1 and gear.y == number.left_y - 1) or
            (gear.x == number.x - 1 and gear.y == number.right_y + 1) or
            (gear.x == number.x + 1 and gear.y == number.left_y - 1) or
            (gear.x == number.x + 1 and gear.y == number.right_y + 1) or
            (gear.x == number.x - 1 and gear.y >= number.left_y and gear.y <= number.right_y) or
            (gear.x == number.x + 1 and gear.y >= number.left_y and gear.y <= number.right_y)
        end)

      case length(adjs) do
        2 -> acc + Enum.reduce(adjs, 1, fn number, acc -> acc * number.value end)
        _ -> acc
      end
    end)
  end
end

IO.read(:stdio, :eof)
|> State.parse()
|> Solution.solve()
|> IO.puts()
