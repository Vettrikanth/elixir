# lib/logs_web/live/alarm_logs_live.ex
defmodule LogsWeb.AlarmLogsLive do
  use LogsWeb, :live_view
  alias Logs.{Alarm, Alarms}

  def mount(_params, _session, socket) do
    # Get alarms from database only once
    alarms = Logs.Alarm.list_alarms()

    socket =
      socket
      |> assign(:alarms, alarms)
      |> assign(:error, nil)
      |> allow_upload(:csv, accept: ~w(.csv), max_entries: 1)

    {:ok, socket}
  end

  def handle_event("download_csv", _params, socket) do
    csv_data = Alarms.to_csv(socket.assigns.alarms)

    socket = push_event(socket, "download", %{
      data: csv_data,
      filename: "alarm_logs_#{DateTime.utc_now() |> Calendar.strftime("%Y%m%d%H%M%S")}.csv"
    })

    {:noreply, socket}
  end

    def handle_event("upload_csv", _params, socket) do
      case uploaded_entries(socket, :csv) do
        [] ->
          {:noreply, assign(socket, error: "No CSV file provided")}

        _entries ->
          consumed = consume_uploaded_entries(socket, :csv, fn meta, _entry ->
            {:ok, File.read!(meta.path)}
          end)

          case consumed do
            [csv_data] ->
              case Logs.Alarm.import_from_csv(csv_data) do
                {:ok, _results} ->
                  # Refresh alarms from database
                  updated_alarms = Logs.Alarm.list_alarms()
                  {:noreply, assign(socket, alarms: updated_alarms, error: nil)}

                {:error, reason} ->
                  {:noreply, assign(socket, error: "Import failed: #{reason}")}
              end

            _ ->
              {:noreply, assign(socket, error: "Error processing uploaded file")}
          end
      end
    end

  end
