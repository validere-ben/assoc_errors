defmodule AssocErrors.Repo do
  use Ecto.Repo,
    otp_app: :assoc_errors,
    adapter: Ecto.Adapters.Postgres
end
