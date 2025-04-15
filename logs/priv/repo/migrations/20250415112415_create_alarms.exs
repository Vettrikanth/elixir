# priv/repo/migrations/20250415112415_create_alarms.exs
defmodule Logs.Repo.Migrations.CreateAlarms do
  use Ecto.Migration

  def change do
    create table(:alarms) do
      add :timestamp, :utc_datetime, null: false
      add :severity, :string, null: false
      add :message, :string, null: false

      timestamps()
    end

    create index(:alarms, [:timestamp])
    create index(:alarms, [:severity])
  end
end
