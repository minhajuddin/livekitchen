defmodule Livekitchen.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      # Livekitchen.Repo,
      # Start the Telemetry supervisor
      LivekitchenWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Livekitchen.PubSub},
      # Start the Endpoint (http/https)
      LivekitchenWeb.Endpoint
      # Start a worker by calling: Livekitchen.Worker.start_link(arg)
      # {Livekitchen.Worker, arg}
    ]

    :place_pixels =
      :ets.new(:place_pixels, [
        :named_table,
        :public,
        {:write_concurrency, true},
        {:read_concurrency, true}
      ])

    :ets.insert(
      :place_pixels,
      for(
        x <- 0..99,
        y <- 0..99,
        do: {{x, y}, ["rgba(#{x},#{y},#{255 - x},1)", "The Board"]}
      )
    )

    LivekitchenWeb.RateLimiter.init()

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Livekitchen.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LivekitchenWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
