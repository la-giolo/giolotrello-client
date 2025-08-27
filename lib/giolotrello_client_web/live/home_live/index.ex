defmodule GiolotrelloClientWeb.HomeLive.Index do
  use GiolotrelloClientWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    token = session["auth_token"]

    socket =
      case fetch_lists(token) do
        {:ok, lists} ->
          socket
          |> assign(:lists, lists)
          |> assign(:selected_task, nil)
          |> assign(:auth_token, token)
        {:error, _} ->
          socket
          |> assign(:lists, [])
          |> assign(:selected_task, nil)
          |> assign(:auth_token, token)
      end

    {:ok, socket}
  end

  @impl true
  def handle_event("show_task", %{"id" => id}, socket) do
    task =
      socket.assigns.lists
      |> Enum.flat_map(& &1["tasks"])
      |> Enum.find(fn t -> to_string(t["id"]) == id end)

    {:noreply, assign(socket, :selected_task, task)}
  end

  @impl true
  def handle_event("close_task", _params, socket) do
    {:noreply, assign(socket, :selected_task, nil)}
  end

  defp fetch_lists(nil), do: {:error, :no_token}

  defp fetch_lists(token) do
    case Req.get("http://giolotrello-api:4000/api/lists",
           headers: [{"authorization", "Bearer " <> token}]
         ) do
      {:ok, %Req.Response{status: 200, body: %{"lists" => lists}}} ->
        {:ok, lists}

      {:ok, %Req.Response{status: status}} ->
        {:error, status}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
