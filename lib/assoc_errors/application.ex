defmodule AssocErrors.Application do
  use Application

  def start(_type, _args) do
    children = [
      AssocErrors.Repo
    ]

    opts = [
      strategy: :one_for_one,
      name: AssocErrors.Supervisor
    ]

    Supervisor.start_link(children, opts)
  end
end
