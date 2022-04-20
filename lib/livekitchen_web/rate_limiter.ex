defmodule LivekitchenWeb.RateLimiter do
  @rps 10

  def init() do
    :rate_limiter =
      :ets.new(:rate_limiter, [
        :named_table,
        :public,
        {:read_concurrency, true},
        {:write_concurrency, true}
      ])
  end

  def rate_limit?(client_id) do
    key = {client_id, :erlang.monotonic_time(:seconds)}

    :ets.update_counter(:rate_limiter, _key = key, _incr_by = 1, _default = {key, 0}) > @rps
  end
end
