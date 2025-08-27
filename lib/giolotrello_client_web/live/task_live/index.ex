defmodule GiolotrelloClientWeb.TaskLive.Index do
  use GiolotrelloClientWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    token = session["auth_token"]
    {:ok, fetch_tasks(socket, token)}
  end

  defp fetch_tasks(socket, token) do
    case Req.get("http://giolotrello-api:4000/api/tasks",
         headers: [{"authorization", "Bearer " <> token}]
       ) do
    {:ok, %Req.Response{status: 200, body: %{"data" => tasks}}} ->
      assign(socket, :tasks, tasks)

    _ ->
      assign(socket, :tasks, [])
  end
  end
end
