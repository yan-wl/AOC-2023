defmodule Solution do
  defp is_digit?(char) do
    char >= 48 and char <= 57
  end

  defp trim_head_non_digits(chars) do
    cond do
      is_digit?(hd(chars)) -> chars
      true -> trim_head_non_digits(tl(chars))
    end
  end

  def extract_calibration_value(word) do
    left = hd(trim_head_non_digits(String.to_charlist(word)))
    right = hd(trim_head_non_digits(String.to_charlist(String.reverse(word))))
    List.to_integer([left, right])
  end
end

words = IO.read(:stdio, :eof)

result =
  String.split(words, "\n")
  |> Enum.filter(fn word -> word != "" end)
  |> Enum.map(fn word -> Solution.extract_calibration_value(word) end)
  |> Enum.sum()

IO.puts(result)
