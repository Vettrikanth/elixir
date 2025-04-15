# lib/logs/db_utils.ex
defmodule Logs.DbUtils do
  def reset_mock_data do
    Logs.Alarm.clear_all_alarms()
    Logs.Alarm.seed_mock_alarms()
    IO.puts("Database reset with fresh mock data")
  end

  def add_more_mock_data do
    additional_alarms = [
      %{timestamp: ~U[2025-04-15 11:00:00Z], severity: "high", message: "Alarm 6: Critical failure"},
      %{timestamp: ~U[2025-04-15 10:45:00Z], severity: "low", message: "Alarm 7: Minor issue"},
      %{timestamp: ~U[2025-04-15 10:30:00Z], severity: "medium", message: "Alarm 8: Moderate warning"},
      %{timestamp: ~U[2025-04-15 11:30:00Z], severity: "medium", message: "Alarm 9: Moderate warning"}
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
