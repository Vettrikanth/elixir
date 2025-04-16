# lib/logs/db_utils.ex
defmodule Logs.DbUtils do
  def reset_mock_data do
    Logs.Alarm.clear_all_alarms()
    Logs.Alarm.seed_mock_alarms()
    IO.puts("Database reset with fresh mock data")
  end

  def add_more_mock_data do
    additional_alarms = [
      %{timestamp: DateTime.new!(~D[2025-04-14], Time.new!(10, 00, 00), "Etc/UTC"), severity: "high", message: "April 14 alarm"},
      %{timestamp: DateTime.new!(~D[2025-04-13], Time.new!(9, 30, 00), "Etc/UTC"), severity: "medium", message: "April 13 alarm"},
      %{timestamp: DateTime.new!(~D[2025-04-12], Time.new!(9, 00, 00), "Etc/UTC"), severity: "low", message: "April 12 alarm"},
      %{timestamp: DateTime.new!(~D[2025-04-11], Time.new!(8, 30, 00), "Etc/UTC"), severity: "high", message: "April 11 alarm"},
      %{timestamp: DateTime.new!(~D[2025-04-10], Time.new!(8, 00, 00), "Etc/UTC"), severity: "medium", message: "April 10 alarm"},
      %{timestamp: DateTime.new!(~D[2025-04-09], Time.new!(10, 00, 00), "Etc/UTC"), severity: "high", message: "April 09 alarm"},
      %{timestamp: DateTime.new!(~D[2025-04-08], Time.new!(9, 30, 00), "Etc/UTC"), severity: "medium", message: "April 08 alarm"},
      %{timestamp: DateTime.new!(~D[2025-04-07], Time.new!(9, 00, 00), "Etc/UTC"), severity: "low", message: "April 07 alarm"},
      %{timestamp: DateTime.new!(~D[2025-04-06], Time.new!(8, 30, 00), "Etc/UTC"), severity: "high", message: "April 06 alarm"},
      %{timestamp: DateTime.new!(~D[2025-04-05], Time.new!(8, 00, 00), "Etc/UTC"), severity: "medium", message: "April 05 alarm"},
    ]

    Enum.each(additional_alarms, &Logs.Alarm.create_alarm/1)
    IO.puts("Added #{length(additional_alarms)} more mock alarms")
  end

  # To check for duplicate data
  def list_all_alarms do
    Logs.Alarm.list_alarms()
    |> Enum.map(fn alarm ->
      "#{alarm.id} | #{alarm.timestamp} | #{alarm.severity} | #{alarm.message}"
    end)
    |> Enum.each(&IO.puts/1)
  end
end
