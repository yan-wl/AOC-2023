defmodule Solution do
  defp is_digit?(str) do
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

  defp extract_head_calibration_value(word) do
    cond do
      String.starts_with?(word, "one") -> 1
      String.starts_with?(word, "two") -> 2
      String.starts_with?(word, "three") -> 3
      String.starts_with?(word, "four") -> 4
      String.starts_with?(word, "five") -> 5
      String.starts_with?(word, "six") -> 6
      String.starts_with?(word, "seven") -> 7
      String.starts_with?(word, "eight") -> 8
      String.starts_with?(word, "nine") -> 9
      is_digit?(String.first(word)) -> String.to_integer(String.first(word))
      true -> extract_head_calibration_value(String.slice(word, 1..-1))
    end
  end

  defp extract_tail_calibration_value(word) do
    cond do
      String.ends_with?(word, "one") -> 1
      String.ends_with?(word, "two") -> 2
      String.ends_with?(word, "three") -> 3
      String.ends_with?(word, "four") -> 4
      String.ends_with?(word, "five") -> 5
      String.ends_with?(word, "six") -> 6
      String.ends_with?(word, "seven") -> 7
      String.ends_with?(word, "eight") -> 8
      String.ends_with?(word, "nine") -> 9
      is_digit?(String.last(word)) -> String.to_integer(String.last(word))
      true -> extract_tail_calibration_value(String.slice(word, 0..-2))
    end
  end

  def extract_calibration_value(word) do
    extract_head_calibration_value(word) * 10 + extract_tail_calibration_value(word)
  end
end

words = IO.read(:stdio, :eof)

result =
  String.split(words, "\n")
  |> Enum.filter(fn word -> word != "" end)
  |> Enum.map(fn word -> Solution.extract_calibration_value(word) end)
  |> Enum.sum()

IO.puts(result)
