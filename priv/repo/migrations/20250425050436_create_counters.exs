defmodule Hello.Repo.Migrations.CreateCounters do
  use Ecto.Migration

  def change do
    create table(:counters) do
      add :count, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
