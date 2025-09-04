defmodule GiolotrelloClientWeb.TaskDetailsComponent do
  use GiolotrelloClientWeb, :live_component

  @impl true
  def update(assigns, socket) do
    socket =
      socket
      |> assign_new(:task, fn -> nil end)
      |> assign_new(:users, fn -> [] end)
      |> assign(assigns)

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="p-4 space-y-4">
      <!-- Title -->
      <h2 class="text-xl font-bold text-gray-800"><%= @task["title"] %></h2>

      <!-- Description -->
      <div>
        <h3 class="text-sm font-medium text-gray-600 mb-1">Description</h3>
        <p class="text-gray-700 whitespace-pre-line">
          <%= @task["description"] || "No description" %>
        </p>
      </div>

      <!-- Assignee -->
      <div>
        <h3 class="text-sm font-medium text-gray-600 mb-1">Assigned To</h3>
        <p class="text-gray-700">
          <%= assignee_name(@task, @users) %>
        </p>
      </div>

      <!-- Action buttons -->
      <div class="flex space-x-2 justify-end">
        <button
          type="button"
          class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600"
          phx-click="edit_task"
          phx-value-id={@task["id"]}
        >
          Edit
        </button>

        <button
          type="button"
          class="bg-gray-300 px-4 py-2 rounded hover:bg-gray-400"
          phx-click="close_task"
        >
          Close
        </button>
      </div>
    </div>
    """
  end

  defp assignee_name(task, users) do
    case task["assignee_id"] do
      nil -> "Unassigned"
      id ->
        case Enum.find(users, fn u -> u["id"] == id end) do
          nil -> "Unknown user"
          user -> user["email"]
        end
    end
  end
end
