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
      |> assign(:selected_task_users, nil)
      |> assign(:creating_task, false)
      |> assign(:editing_task, false)
      |> assign(:creating_list, false)
      |> assign(:new_list_title, "")
      |> assign(:auth_token, token)

    {:ok, socket}
  end

  @impl true
  def handle_event("new_list", _params, socket) do
    {:noreply, assign(socket, :creating_list, true)}
  end

  @impl true
  def handle_event("cancel_new_list", _params, socket) do
    {:noreply, assign(socket, creating_list: false, new_list_title: "")}
  end

  @impl true
  def handle_event("create_list", %{"title" => title}, socket) do
    token = socket.assigns[:auth_token]

    case GiolotrelloClient.API.Lists.create_list(title, token) do
      {:ok, %Tesla.Env{status: status, body: %{"data" => list}}} when status in [200, 201] ->
        {:noreply,
        socket
        |> update(:lists, fn lists -> lists ++ [list] end)
        |> assign(:creating_list, false)
        |> put_flash(:info, "List created successfully")}

      {:ok, %Tesla.Env{status: status, body: body}} ->
        {:noreply, put_flash(socket, :error, "Create failed (#{status}): #{inspect(body)}")}

      {:error, reason} ->
        {:noreply, put_flash(socket, :error, "Create list error: #{inspect(reason)}")}
    end
  end

  @impl true
  def handle_event("delete_list", %{"id" => id}, socket) do
    token = socket.assigns[:auth_token]

    case GiolotrelloClient.API.Lists.delete_list(id, token) do
      {:ok, %Tesla.Env{status: 204}} ->
        {:noreply,
        socket
        |> update(:lists, fn lists ->
          Enum.reject(lists, fn list ->
            to_string(list["id"]) == id
          end)
        end)
        |> put_flash(:info, "List deleted successfully")}

      {:ok, %Tesla.Env{status: status, body: body}} ->
        {:noreply, put_flash(socket, :error, "Delete failed (#{status}): #{inspect(body)}")}

      {:error, reason} ->
        {:noreply, put_flash(socket, :error, "Delete list error: #{inspect(reason)}")}
    end
  end

  @impl true
  def handle_event("show_task", %{"id" => id}, socket) do
    list =
      Enum.find(socket.assigns.lists, fn l ->
        Enum.any?(l["tasks"], fn t -> to_string(t["id"]) == id end)
      end)

    task =
      list["tasks"]
      |> Enum.find(fn t -> to_string(t["id"]) == id end)

    {:noreply,
    socket
    |> assign(:selected_task, task)
    |> assign(:selected_task_users, list["users"])}
  end

  @impl true
  def handle_event("close_task", _params, socket) do
    {:noreply,
    socket
    |> assign(:creating_task, false)
    |> assign(:editing_task, false)
    |> assign(:selected_task, nil)}
  end

  def handle_event("new_task", %{"list_id" => list_id}, socket) do
    {:noreply,
    socket
    |> assign(:creating_task, true)
    |> assign(:editing_task, false)
    |> assign(:selected_task, %{
          "id" => "new-#{list_id}",
          "list_id" => list_id,
          "title" => "",
          "description" => ""
        })}
  end

  @impl true
  def handle_event("cancel_create_task", _params, socket) do
    {:noreply,
    socket
    |> assign(:creating_task, false)
    |> assign(:selected_task, nil)}
  end

  @impl true
  def handle_event("create_task", %{"title" => title, "description" => description, "list_id" => list_id} = params, socket) do
    token = socket.assigns[:auth_token]

    case GiolotrelloClient.API.Tasks.create_task(params, token) do
      {:ok, %Tesla.Env{status: 201, body: task}} ->
        {:noreply,
        socket
        |> assign(:tasks, [task | socket.assigns.tasks])
        |> assign(:creating_task, false)}

      {:ok, %Tesla.Env{status: status, body: body}} ->
        {:noreply, put_flash(socket, :error, "Create failed (#{status}): #{inspect(body)}")}

      {:error, reason} ->
        {:noreply, put_flash(socket, :error, "Create task error: #{inspect(reason)}")}
    end
  end


  @impl true
  def handle_event("delete_task", %{"id" => id}, socket) do
    token = socket.assigns[:auth_token]

    case GiolotrelloClient.API.Tasks.delete_task(id, token) do
      {:ok, %Tesla.Env{status: 204}} ->
        updated_lists = Enum.map(socket.assigns.lists, fn list ->
          tasks = Enum.reject(list["tasks"], fn t -> Integer.to_string(t["id"]) == id end)
          Map.put(list, "tasks", tasks)
        end)

        {:noreply,
        socket
        |> assign(:lists, updated_lists)
        |> assign(:selected_task, nil)}

      {:ok, %Tesla.Env{status: status, body: body}} ->
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
    {:noreply,
    socket
    |> assign(:editing_task, false)
    |> assign(:selected_task, nil)}
  end

  @impl true
  def handle_event(
    "update_task",
    %{
      "task_id" => task_id,
      "title" => title,
      "description" => desc,
      "assignee_id" => assignee_id
    } = params,
    socket
  ) do
    token = socket.assigns[:auth_token]

    case GiolotrelloClient.API.Tasks.update_task(task_id, params, token) do
      {:ok, %Tesla.Env{status: 200, body: updated_task}} ->
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

        {:noreply,
        socket
        |> assign(:lists, updated_lists)
        |> assign(:selected_task, nil)
        |> assign(:editing_task, false)}

      {:ok, %Tesla.Env{status: status, body: body}} ->
        {:noreply, put_flash(socket, :error, "Update failed (#{status}): #{inspect(body)}")}

      {:error, reason} ->
        {:noreply, put_flash(socket, :error, "Update error: #{inspect(reason)}")}
    end
  end

  @impl true
  def handle_event(
    "reorder_task",
    %{
      "task_id" => task_id,
      "after_task_id" => after_task_id,
      "list_id" => list_id
    } = params,
    socket
  ) do
    token = socket.assigns[:auth_token]

    case GiolotrelloClient.API.Tasks.reorder_task(task_id, params, token) do
      {:ok, %Tesla.Env{status: 200, body: updated_task}} ->
        updated_lists =
          Enum.map(socket.assigns.lists, fn list ->
            if list["id"] == updated_task["list_id"] do
              Map.update!(list, "tasks", fn tasks ->
                Enum.map(tasks, fn t ->
                  if t["id"] == updated_task["id"], do: updated_task, else: t
                end)
              end)
            else
              list
            end
          end)

        {:noreply,
        socket
        |> assign(:lists, updated_lists)}

      {:ok, %Tesla.Env{status: status, body: body}} ->
        {:noreply, put_flash(socket, :error, "Reorder failed (#{status}): #{inspect(body)}")}

      {:error, reason} ->
        {:noreply, put_flash(socket, :error, "Reorder error: #{inspect(reason)}")}
    end
  end

  @impl true
  def handle_event("add_comment", %{"task_id" => task_id, "body" => body}, socket) do
    token = socket.assigns[:auth_token]
    task_id_int = String.to_integer(task_id)

    case GiolotrelloClient.API.Comments.create_comment(task_id, body, token) do
      {:ok, %Tesla.Env{status: 201, body: %{"data" => new_comment}}} ->
        updated_lists =
          Enum.map(socket.assigns.lists, fn list ->
            updated_tasks =
              Enum.map(list["tasks"], fn task ->
                if task["id"] == task_id_int do
                  Map.update(task, "comments", [new_comment], fn comments -> comments ++ [new_comment] end)
                else
                  task
                end
              end)

            Map.put(list, "tasks", updated_tasks)
          end)

        updated_selected_task =
          if socket.assigns.selected_task && socket.assigns.selected_task["id"] == task_id_int do
            Map.update(socket.assigns.selected_task, "comments", [new_comment], fn comments -> comments ++ [new_comment] end)
          else
            socket.assigns.selected_task
          end

        {:noreply,
        socket
        |> assign(:lists, updated_lists)
        |> assign(:selected_task, updated_selected_task)}

      {:ok, %Tesla.Env{status: status, body: body}} ->
        {:noreply, put_flash(socket, :error, "Add comment failed (#{status}): #{inspect(body)}")}

      {:error, reason} ->
        {:noreply, put_flash(socket, :error, "Add comment error: #{inspect(reason)}")}
    end
  end

  defp fetch_lists(nil), do: {:error, :no_token}

  defp fetch_lists(token) do
    case GiolotrelloClient.API.Lists.get_all_lists(token) do
      {:ok, %Tesla.Env{status: 200, body: %{"lists" => lists}}} ->
        {:ok, lists}

      {:ok, %Tesla.Env{status: status}} ->
        {:error, status}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
