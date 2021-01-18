import Config

config :assoc_errors,
  ecto_repos: [AssocErrors.Repo],
  generators: [binary_id: true]

config :assoc_errors, AssocErrors.Repo,
  username: "postgres",
  password: "postgres",
  database: "assoc_errors_dev",
  hostname: "localhost",
  port: 5432
