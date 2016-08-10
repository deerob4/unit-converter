defmodule UnitConverter.PageController do
  use UnitConverter.Web, :controller
  import String, only: [capitalize: 1]
  import UnitConverter.Converter, only: [convert: 2, get_conversions: 0]

  def index(conn, _params) do
    render conn, "index.html", conversions: conversions
  end

  def do_convert(conn, %{"value" => value, "from" => from, "to" => to}) do
    case convert(String.to_integer(value), from: from, to: to) do
      {:ok, answer} ->
        json conn, %{answer: answer}

      {:error, reason} ->
        conn
        |> put_status(400)
        |> json(%{error: reason})
    end
  end

  def update_conversions(conn, _params) do
    Code.load_file("lib/unit_converter/converter.ex")
    json conn, %{conversions: conversions}
  end

  defp conversions do
    get_conversions |> prettify_conversions
  end

  defp prettify_conversions(conversions) do
    conversions
    |> Enum.map(&("#{capitalize &1["from"]} to #{capitalize &1["to"]}"))
  end
end
