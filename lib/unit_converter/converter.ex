defmodule UnitConverter.Converter do
  @conversion_file "priv/static/conversions.json"
  @conversions []

  %{"conversions" => conversions} =
    @conversion_file
    |> File.read!
    |> Poison.decode!

  # Goes through each conversion in the file and
  # constructs a unique function using its formula.
  for conversion <- conversions do
    from = conversion["from"]
    to = conversion["to"]
    formula = conversion["formula"]

    # Add the current conversion to the list. We have
    # to use a constant because the base file is only
    # accessible during compile time.
    @conversions @conversions ++ [conversion]

    @doc """
    Converts `value` from the unit specified by `from` to
    the unit specified by `to`.
    """
    def convert(value, [from: unquote(from), to: unquote(to)])
    when is_number(value) do
      bindings = [x: value, pi: :math.pi]
      {result, _} = Code.eval_string(unquote(formula), bindings)
      {:ok, result}
    end
  end

  def convert(_, [from: _, to: _]), do: {:error, :invalid_conversion}

  @doc "Returns the available conversions."
  def get_conversions, do: @conversions
end
