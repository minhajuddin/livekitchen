defmodule LivekitchenWeb.UserLive do
  use LivekitchenWeb, :live_view
  alias Livekitchen.User

  def mount(_params, _session, socket) do
    {:ok, assign(socket, changeset: User.changeset(%User{}, %{}))}
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    {:noreply, assign(socket, changeset: User.changeset(socket.assigns.changeset, user_params))}
  end

  def render(assigns) do
    ~H"""
    <h1>Hello</h1>
    <.form let={f} for={@changeset} phx-change="validate">
      <%= label f, :email %>
      <%= text_input f, :email %>
      <%= error_tag f, :email %>

      <%= label f, :password_hash %>
      <%= text_input f, :password_hash %>
      <%= error_tag f, :password_hash %>

      <%= submit "Create User", phx_disable_with: "Creating user ..." %>

    </.form>
    """
  end
end
