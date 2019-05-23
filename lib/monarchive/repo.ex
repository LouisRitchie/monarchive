defmodule Monarchive.Repo do
  use Ecto.Repo,
    otp_app: :monarchive,
    adapter: Ecto.Adapters.Postgres
end
