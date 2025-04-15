defmodule LogsWeb.AlarmLogsLive do
  use LogsWeb, :live_view
  alias Logs.Alarms

  def mount(_params, _session, socket) do
    alarms = Alarms.generate_mock_alarms()
    socket =
      socket
      |> assign(:alarms, alarms)
      |> assign(:error, nil)
      |> allow_upload(:csv, accept: ~w(.csv), max_entries: 1)

    {:ok, socket}
  end

  def handle_event("download_csv", _params, socket) do
    csv_data = Alarms.to_csv(socket.assigns.alarms)

    # Send the actual CSV data to the client
    socket = push_event(socket, "download", %{
      data: csv_data,
      filename: "alarm_logs_#{DateTime.utc_now() |> DateTime.to_iso8601()}.csv"
    })

    {:noreply, socket}
  end

  # Other events and callbacks...
end
