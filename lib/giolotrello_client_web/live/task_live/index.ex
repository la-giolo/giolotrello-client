defmodule GiolotrelloClientWeb.TaskLive.Index do
  use GiolotrelloClientWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, fetch_tasks(socket)}
  end

  defp fetch_tasks(socket) do
    # Call API using HTTP client (Finch or HTTPoison)
    case Req.get!("http://giolotrello-api:4000/api/tasks") do
      %Req.Response{status: 200, body: %{"data" => tasks}} ->
        assign(socket, :tasks, tasks)

      _ ->
        assign(socket, :tasks, [])
    end
  end
end
