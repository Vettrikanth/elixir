# lib/logs/alarm.ex
defmodule Logs.Alarm do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "alarms" do
    field :timestamp, :utc_datetime
    field :severity, :string
    field :message, :string

    timestamps()
  end

  def changeset(alarm, attrs) do
    alarm
    |> cast(attrs, [:timestamp, :severity, :message])
    |> validate_required([:timestamp, :severity, :message])
    |> validate_inclusion(:severity, ["low", "medium", "high"])
  end

  def list_alarms do
    Logs.Repo.all(from a in __MODULE__, order_by: [desc: a.timestamp])
  end

  def create_alarm(attrs) do
    %__MODULE__{}
    |> changeset(attrs)
    |> Logs.Repo.insert()
  end

  def get_alarm!(id), do: Logs.Repo.get!(__MODULE__, id)

  def import_from_csv(csv_data) do
    # IO.puts("import_from_csv called")
    # IO.inspect(label: "Parsed Alarms")

    case Logs.Alarms.from_csv(csv_data) do
      {:ok, alarms} ->
        Logs.Repo.transaction(fn ->
          results = Enum.map(alarms, fn alarm ->
            # Check for duplicates based on timestamp and message
            query = from a in __MODULE__,
                    where: a.timestamp == ^alarm.timestamp and
                           a.message == ^alarm.message

            case Logs.Repo.exists?(query) do
              true ->
                # Skip duplicate
                {:ok, :skipped}
              false ->
                # Insert new alarm
                create_alarm(%{
                  timestamp: alarm.timestamp,
                  severity: alarm.severity,
                  message: alarm.message
                })
            end
          end)

          success_count = Enum.count(results, fn
            {:ok, %Logs.Alarm{}} -> true
            _ -> false
          end)

          %{total: length(results), inserted: success_count}
        end)

      {:error, reason} ->
        {:error, reason}
    end
  end

  def clear_all_alarms do
    Logs.Repo.delete_all(__MODULE__)
  end


def seed_mock_alarms do
  clear_all_alarms()

  mock_alarms = [
    %{timestamp: DateTime.new!(~D[2025-04-15], Time.new!(10, 00, 00), "Etc/UTC"), severity: "high", message: "Alarm 1: System overload"},
    %{timestamp: DateTime.new!(~D[2025-04-15], Time.new!(9, 30, 00), "Etc/UTC"), severity: "medium", message: "Alarm 2: System warning"},
    %{timestamp: DateTime.new!(~D[2025-04-15], Time.new!(9, 00, 00), "Etc/UTC"), severity: "low", message: "Alarm 3: System failure"},
    %{timestamp: DateTime.new!(~D[2025-04-15], Time.new!(8, 30, 00), "Etc/UTC"), severity: "high", message: "Alarm 4: System overload"},
    %{timestamp: DateTime.new!(~D[2025-04-15], Time.new!(8, 00, 00), "Etc/UTC"), severity: "medium", message: "Alarm 5: System warning"},
  ]

  Enum.each(mock_alarms, &create_alarm/1)
end
end
