defmodule LivekitchenWeb.RegistrationLive do
  use LivekitchenWeb, :live_view
  alias LivekitchenWeb.Forms.RegistrationForm
  require Logger

  def mount(_params, _session, socket) do
    {:ok, assign(socket, registration_form: RegistrationForm.form())}
  end

  def render(assigns) do
    ~H"""
    <h1>Register</h1>
    <.form let={f} for={@registration_form} phx-change="validate" phx-submit="save">

      <%= inspect @registration_form %>

      <%= label f, :email %>
      <%= text_input f, :email %>
      <%= error_tag f, :email %>

      <%= label f, :password %>
      <%= password_input f, :password, value: input_value(f, :password) %>
      <%= error_tag f, :password %>

      <%= label f, :password_confirmation%>
      <%= password_input f, :password_confirmation %>
      <%= error_tag f, :password_confirmation %>

      <%= submit "Register", phx_disable_with: "Saving..." %>
    </.form>
    """
  end

  def handle_event("validate", %{"registration_form" => registration_form}, socket) do
    Logger.info("validating", registration_form: registration_form)
    {:noreply, assign(socket, registration_form: RegistrationForm.validate(registration_form))}
  end

  def handle_event("save", %{"registration_form" => registration_form}, socket) do
    :timer.sleep(1000)
    {:noreply, socket}
  end
end
