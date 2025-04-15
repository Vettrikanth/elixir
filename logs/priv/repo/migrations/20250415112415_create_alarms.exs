# Create migration: mix ecto.gen.migration create_alarms
defmodule Logs.Repo.Migrations.CreateAlarms do
  use Ecto.Migration

  def change do
    create table(:alarms) do
      add :timestamp, :utc_datetime, null: false
      add :severity, :string, null: false
      add :message, :text, null: false

      timestamps()
    end

    create index(:alarms, [:timestamp])
    create index(:alarms, [:severity])
  end
end
