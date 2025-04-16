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
      |> allow_upload(:csv, accept: [".csv"], max_entries: 1)

    {:ok, socket}
  end
  
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
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
    IO.inspect(socket.assigns.uploads.csv, label: "Uploads state")

    case uploaded_entries(socket, :csv) do
      [] ->
        IO.inspect("No uploaded entries found", label: "Upload issue")
        {:noreply, assign(socket, error: "No CSV file provided")}

      entries ->
        IO.inspect(entries, label: "Entries found")

        # Try a different approach to read the file
        consumed =
          consume_uploaded_entries(socket, :csv, fn %{path: path}, _entry ->
            case File.read(path) do
              {:ok, binary} ->
                IO.inspect(byte_size(binary), label: "File size in bytes")
                {:ok, binary}
              {:error, reason} ->
                IO.inspect(reason, label: "File read error")
                {:error, reason}
            end
          end)

        IO.inspect(consumed, label: "Consumed result")

        case consumed do
          [csv_data] when is_binary(csv_data) ->
            IO.inspect(byte_size(csv_data), label: "CSV data size")
            case Logs.Alarm.import_from_csv(csv_data) do
              {:ok, results} ->
                IO.inspect(results, label: "Import results")
                # Refresh alarms from database
                updated_alarms = Logs.Alarm.list_alarms()
                {:noreply, assign(socket, alarms: updated_alarms, error: nil)}

              {:error, reason} ->
                IO.inspect(reason, label: "Import error")
                {:noreply, assign(socket, error: "Import failed: #{reason}")}
            end

          [{:error, reason}] ->
            IO.inspect(reason, label: "Consumed error")
            {:noreply, assign(socket, error: "Error reading file: #{reason}")}

          _ ->
            IO.inspect("Unexpected consumed result", label: "Consumed unexpected")
            {:noreply, assign(socket, error: "Error processing uploaded file")}
        end
    end
  end

  end
