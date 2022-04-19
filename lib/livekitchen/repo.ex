defmodule Livekitchen.Repo do
  use Ecto.Repo,
    otp_app: :livekitchen,
    adapter: Ecto.Adapters.Postgres
end
