defmodule Logs.Alarms do
  alias NimbleCSV.RFC4180, as: CSV

  defstruct [:id, :timestamp, :severity, :message]

  def generate_mock_alarms(_count \\ 5) do
    [
      %__MODULE__{id: 1, timestamp: ~U[2025-04-15 10:00:00Z], severity: "high", message: "Alarm 1: System overload"},
      %__MODULE__{id: 2, timestamp: ~U[2025-04-15 09:30:00Z], severity: "medium", message: "Alarm 2: System warning"},
      %__MODULE__{id: 3, timestamp: ~U[2025-04-15 09:00:00Z], severity: "low", message: "Alarm 3: System failure"},
      %__MODULE__{id: 4, timestamp: ~U[2025-04-15 08:30:00Z], severity: "high", message: "Alarm 4: System overload"},
      %__MODULE__{id: 5, timestamp: ~U[2025-04-15 08:00:00Z], severity: "medium", message: "Alarm 5: System warning"}
    ]
  end

  def to_csv(alarms) do
    IO.inspect(alarms, label: "DEBUG: Alarms for CSV")
    headers = ["id", "timestamp", "severity", "message"]
    rows = Enum.map(alarms, fn alarm ->
      [to_string(alarm.id), DateTime.to_string(alarm.timestamp), alarm.severity, alarm.message]
    end)
    csv_data = CSV.dump_to_iodata([headers | rows])
    IO.inspect(csv_data, label: "DEBUG: CSV iolist")
    csv_string = IO.iodata_to_binary(csv_data)
    IO.inspect(csv_string, label: "DEBUG: CSV string")
    csv_string
  end

  def from_csv(data) do
    try do
      parsed =
        data
        |> CSV.parse_string()
        |> Enum.map(fn [id, timestamp, severity, message] ->
          %__MODULE__{
            id: String.to_integer(id),
            timestamp: DateTime.from_iso8601(timestamp) |> elem(1),
            severity: severity,
            message: message
          }
        end)
      {:ok, parsed}
    rescue
      _ -> {:error, "Invalid CSV format"}
    end
  end
end
