# lib/logs/alarms.ex
defmodule Logs.Alarms do
  alias NimbleCSV.RFC4180, as: CSV
  # alias Logs.Alarm

  def to_csv(alarms) do
    headers = ["timestamp", "severity", "message"]
    rows = Enum.map(alarms, fn alarm ->
      [DateTime.to_string(alarm.timestamp), alarm.severity, alarm.message]
    end)
    csv_data = CSV.dump_to_iodata([headers | rows])
    IO.iodata_to_binary(csv_data)
  end

  def from_csv(data) do
    IO.inspect(data, label: "Incoming data")

    try do
      parsed_rows =
        data
        |> String.replace("\r\n", "\n")  # Normalize line endings to Unix format
        |> CSV.parse_string()           # Parse the CSV string into rows
        |> IO.inspect(label: "parsed rows")
        |> Enum.reject(fn row -> Enum.all?(row, &(&1 == "")) end)  # Remove blank rows

      IO.inspect(parsed_rows, label: "Parsed rows after cleanup")

      headers = ["timestamp", "severity", "message"]
      rows = parsed_rows

      IO.inspect(headers, label: "Headers")
      IO.inspect(rows, label: "Rows")

      required_headers = ["timestamp", "severity", "message"]
      unless Enum.all?(required_headers, fn expected ->
        Enum.member?(headers, expected)
      end) do
        raise "Invalid CSV headers. Required: timestamp, severity, message"
      end

      # Find the position of each column
      timestamp_pos = Enum.find_index(headers, &(&1 == "timestamp"))
      severity_pos = Enum.find_index(headers, &(&1 == "severity"))
      message_pos = Enum.find_index(headers, &(&1 == "message"))

      parsed = Enum.map(rows, fn row ->
        timestamp_str = Enum.at(row, timestamp_pos)
        {:ok, timestamp, _} = DateTime.from_iso8601(timestamp_str)
        severity = Enum.at(row, severity_pos)
        message = Enum.at(row, message_pos)

        %{
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
