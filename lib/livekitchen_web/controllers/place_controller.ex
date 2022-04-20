defmodule LivekitchenWeb.PlaceController do
  use LivekitchenWeb, :controller
  alias LivekitchenWeb.PlaceLive

  def create(conn, %{"x" => x, "y" => y, "color" => color} = params) do
    player = Map.get(params, "player", "unknown")

    if rate_limit?(conn, player) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(
        429,
        ~s[{"error": "Rate limit exceeded. Maximal rate is 5 requests per second."}]
      )
    else
      set_pixel(conn, x, y, color, player)
    end
  end

  def create(conn, _) do
    conn
    |> put_resp_content_type("application/json")
    |> Plug.Conn.send_resp(:not_found, "{}")
  end

  defp rate_limit?(_, "unknown"), do: false

  defp rate_limit?(_conn, player) do
    LivekitchenWeb.RateLimiter.rate_limit?(player)
  end

  defp set_pixel(conn, x, y, color, player) do
    case PlaceLive.set_pixel(x, y, color, player) do
      {:ok, _} ->
        conn
        |> put_resp_content_type("application/json")
        |> Plug.Conn.send_resp(:ok, "{}")

      {:error, :invalid_coords} ->
        conn
        |> put_resp_content_type("application/json")
        |> Plug.Conn.send_resp(:not_found, "{}")
    end
  end
end
