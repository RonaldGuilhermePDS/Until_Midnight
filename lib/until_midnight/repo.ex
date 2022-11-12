defmodule UntilMidnight.Repo do
  use Ecto.Repo,
    otp_app: :until_midnight,
    adapter: Ecto.Adapters.Postgres
end
