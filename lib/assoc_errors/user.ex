defmodule AssocErrors.User do
  use Ecto.Schema

  alias AssocErrors.Permission

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @fields [:email]

  schema "users" do
    field(:email, :string)
    has_many(:permissions, Permission, on_replace: :delete)
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @fields)
    |> put_assoc(:permissions, params.permissions)
  end
end
