defmodule GiolotrelloClientWeb.HomeLive.Index do
  use GiolotrelloClientWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    token = session["auth_token"]

    lists =
      case fetch_lists(token) do
        {:ok, lists} -> lists
        {:error, _} -> []
      end

    socket =
      socket
      |> assign(:lists, lists)
      |> assign(:selected_task, nil)
      |> assign(:editing_task, false)
      |> assign(:auth_token, token)

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

  @impl true
  def handle_event("delete_task", %{"id" => id}, socket) do
    token = socket.assigns[:auth_token]

    case Req.delete("http://giolotrello-api:4000/api/tasks/#{id}",
          headers: [{"authorization", "Bearer " <> token}]
        ) do
      {:ok, %Req.Response{status: 204}} ->
        updated_lists = Enum.map(socket.assigns.lists, fn list ->
          tasks = Enum.reject(list["tasks"], fn t -> Integer.to_string(t["id"]) == id end)
          Map.put(list, "tasks", tasks)
        end)

        {:noreply,
        socket
        |> assign(:lists, updated_lists)
        |> assign(:selected_task, nil)}

      {:ok, %Req.Response{status: status, body: body}} ->
        {:noreply, put_flash(socket, :error, "Delete failed (#{status}): #{inspect(body)}")}

      {:error, reason} ->
        {:noreply, put_flash(socket, :error, "Delete error: #{inspect(reason)}")}
    end
  end

  @impl true
  def handle_event("edit_task", %{"id" => id}, socket) do
    task =
      socket.assigns.lists
      |> Enum.flat_map(& &1["tasks"])
      |> Enum.find(fn t -> t["id"] == String.to_integer(id) end)

    {:noreply, assign(socket, selected_task: task, editing_task: true)}
  end

  @impl true
  def handle_event("cancel_edit", _params, socket) do
    {:noreply, assign(socket, :editing_task, false)}
  end

  @impl true
  def handle_event("update_task", %{"task_id" => task_id, "title" => title, "description" => desc}, socket) do
    token = socket.assigns[:auth_token]

    case Req.put("http://giolotrello-api:4000/api/tasks/#{task_id}",
          json: %{
            "task" => %{
              "title" => title,
              "description" => desc
            }
          },
          headers: [{"authorization", "Bearer " <> token}]
        ) do
      {:ok, %Req.Response{status: 200, body: updated_task}} ->
        updated_lists =
          Enum.map(socket.assigns.lists, fn list ->
            if list["id"] == updated_task["list_id"] do
              Map.update!(list, "tasks", fn tasks ->
                Enum.map(tasks, fn t -> if t["id"] == updated_task["id"], do: updated_task, else: t end)
              end)
            else
              list
            end
          end)

        IO.inspect(updated_lists, label: "GIOLO WAS HERE")

        {:noreply,
        socket
        |> assign(:lists, updated_lists)
        |> assign(:selected_task, nil)
        |> assign(:editing_task, false)}

      {:ok, %Req.Response{status: status, body: body}} ->
        {:noreply, put_flash(socket, :error, "Update failed (#{status}): #{inspect(body)}")}

      {:error, reason} ->
        {:noreply, put_flash(socket, :error, "Update error: #{inspect(reason)}")}
    end
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
