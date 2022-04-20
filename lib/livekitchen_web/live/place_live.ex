defmodule LivekitchenWeb.PlaceLive do
  use LivekitchenWeb, :live_view
  require Logger

  @width 100
  @height 100

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      schedule_tick()
      send(self(), :tick)
    end

    {:ok,
     assign(socket, message: "Hello", pixels: pixels(), player_pixel_counts: player_pixel_counts())}
  end

  def set_pixel(x, y, color, player) when is_binary(x) and is_binary(y) and is_binary(color) do
    case {Integer.parse(x), Integer.parse(y)} do
      {{x, _}, {y, _}} ->
        set_pixel(x, y, color, player)

      _ ->
        {:error, :invalid_coords}
    end
  end

  def set_pixel(x, y, color, player)
      when is_integer(x) and is_integer(y) and is_binary(color) do
    case {x, y} do
      {x, y} when x >= 0 and x < @width and y >= 0 and y < @height ->
        :ets.insert(:place_pixels, {{x, y}, [color, player]})
        {:ok, true}

      _ ->
        {:error, :invalid_coords}
    end
  end

  def player_pixel_counts() do
    :ets.tab2list(:place_pixels)
    |> Stream.map(fn {_, [_, player]} -> player end)
    |> Enum.group_by(& &1)
    |> Enum.map(fn {k, vals} -> {k, Enum.count(vals)} end)
    |> Enum.sort_by(fn {_k, v} -> -1 * v end)
  end

  defp pixels() do
    :ets.tab2list(:place_pixels) |> Enum.into(%{})
  end

  defp schedule_tick() do
    # Logger.warn "ticking away"
    Process.send_after(self(), :tick, 1000)
  end

  @impl true
  def handle_info(:tick, socket) do
    schedule_tick()
    {:noreply, assign(socket, pixels: pixels(), player_pixel_counts: player_pixel_counts())}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h2>Leaderboard</h2>
    <ol>
      <%= for {player, count} <- @player_pixel_counts do %>
        <li><%= player %>: <%= count %> pixels</li>
      <% end %>
    </ol>
    <hr />
    <svg viewBox="0 0 1000 1000" xmlns="http://www.w3.org/2000/svg">
      <%= for  x <- 0..99, y <- 0..99  do %>
        <rect x={ x * 10 } y={ y * 10 } style={"fill: #{hd @pixels[{x, y}]}"} width="10" height="10">
          <title>
          (<%= x %>, <%= y %>): <%= @pixels[{x, y}] |> Enum.join(":") %>
          </title>
        </rect>
      <% end %>
    </svg>
    """
  end
end
