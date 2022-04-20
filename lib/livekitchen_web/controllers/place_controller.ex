defmodule LivekitchenWeb.PlaceController do
  use LivekitchenWeb, :controller
  alias LivekitchenWeb.PlaceLive

  def create(conn, %{"x" => x, "y" => y, "color" => color} = params) do
    author = Map.get(params, "author", "unknown")
    case PlaceLive.set_pixel(x, y, color, author) do
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

  def create(conn, _) do
    conn
    |> put_resp_content_type("application/json")
    |> Plug.Conn.send_resp(:not_found, "{}")
  end
end
