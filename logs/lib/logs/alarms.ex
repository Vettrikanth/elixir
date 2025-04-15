# lib/logs/alarms.ex
defmodule Logs.Alarms do
  alias NimbleCSV.RFC4180, as: CSV
  # alias Logs.Alarm

  def to_csv(alarms) do
    headers = ["id", "timestamp", "severity", "message"]
    rows = Enum.map(alarms, fn alarm ->
      [to_string(alarm.id), DateTime.to_string(alarm.timestamp), alarm.severity, alarm.message]
    end)
    csv_data = CSV.dump_to_iodata([headers | rows])
    IO.iodata_to_binary(csv_data)
  end

  def from_csv(data) do
    try do
      [headers | rows] = CSV.parse_string(data)

      # Check if headers match expected format
      unless Enum.all?(["id", "timestamp", "severity", "message"], fn expected ->
        Enum.member?(headers, expected)
      end) do
        raise "Invalid CSV headers"
      end

      # Find the position of each column
      id_pos = Enum.find_index(headers, &(&1 == "id"))
      timestamp_pos = Enum.find_index(headers, &(&1 == "timestamp"))
      severity_pos = Enum.find_index(headers, &(&1 == "severity"))
      message_pos = Enum.find_index(headers, &(&1 == "message"))

      parsed = Enum.map(rows, fn row ->
        id = Enum.at(row, id_pos) |> String.to_integer()
        timestamp_str = Enum.at(row, timestamp_pos)
        {:ok, timestamp, _} = DateTime.from_iso8601(timestamp_str)
        severity = Enum.at(row, severity_pos)
        message = Enum.at(row, message_pos)

        %{
          id: id,
          timestamp: timestamp,
          severity: severity,
          message: message
        }
      end)
      {:ok, parsed}
    rescue
      e -> {:error, "Invalid CSV format: #{inspect(e)}"}
    end
  end
end
