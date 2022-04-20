defmodule LivekitchenWeb.SinkLive do
  use Phoenix.LiveView
  alias TheButton

  def mount(_params, _session, socket) do
    {:ok, assign(socket, message: "Hello, world!")}
  end

  def render(assigns) do
    ~H"""
    <h1>the sink</h1>
    <p>
      <%= @message %>
    </p>
    <.button value="Save" />
    <hr />
    <%= for i <- 1..10 do %>
      <p>
        <h3><%= i %></h3>
        <.live_component module={TheButton} id={"btn-#{i}"} value="The Button" index={i} />
      </p>
    <% end %>
    <hr />
    """
  end

  def button(assigns) do
    ~H"""
    Booya
    <button phx-click="bang">
      <%= @value %>
    </button>
    """
  end

  def handle_event("bang", _, socket) do
    {:noreply, assign(socket, message: "BANG!")}
  end
end

defmodule TheButton do
  use Phoenix.LiveComponent

  def mount(socket) do
    {:ok, assign(socket, message: "Hello, world!", pid: inspect(self()))}
  end

  def handle_event("bang", _, socket) do
    {:noreply, assign(socket, message: socket.assigns.message <> " BANG!")}
  end

  def render(assigns) do
    ~H"""
    <div>
      <h2>The big button <%= @pid %></h2>
      <button phx-click="bang" phx-target={@myself}>
        <%= @value %> - <%= @index %>
      </button>
      <p>
        <%= @message %>
      </p>
    </div>
    """
  end
end
