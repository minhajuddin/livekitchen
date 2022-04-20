defmodule LivekitchenWeb.Forms.RegistrationForm do
  use Ecto.Schema
  import Ecto.Changeset
  require Logger

  @primary_key false
  embedded_schema do
    field :email, :string
    field :password, :string
    field :password_confirmation, :string
  end

  @spec form :: Ecto.Changeset.t()
  def form, do: cast(%__MODULE__{}, %{}, [])

  def validate(registration_form) do
    %__MODULE__{}
    |> cast(registration_form, [:email, :password, :password_confirmation])
    |> validate_required([:email, :password, :password_confirmation])
    |> validate_format(:email, ~r/@/)
    |> validate_confirmation(:password)
    |> Map.put(:action, :insert)
  end
end
