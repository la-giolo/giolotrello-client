defmodule GiolotrelloClientWeb.TaskFormComponent do
  use GiolotrelloClientWeb, :live_component

  @impl true
  def update(assigns, socket) do
    socket =
      socket
      |> assign_new(:action, fn -> "create" end)
      |> assign_new(:task, fn -> nil end)
      |> assign_new(:users, fn -> [] end)
      |> assign(assigns)

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <form phx-submit={form_event(@action)} class="flex flex-col space-y-4">
      <%= if @action == "edit" do %>
        <input type="hidden" name="task_id" value={@task["id"]} />
      <% else %>
        <input type="hidden" name="list_id" value={@list_id} />
      <% end %>

      <!-- Title -->
      <div>
        <label for="title" class="block text-sm font-medium text-gray-700 mb-1">Task Title</label>
        <input
          id="title"
          type="text"
          name="title"
          value={@task && @task["title"]}
          placeholder="Task title"
          class="border rounded p-2 w-full focus:outline-none focus:ring-2 focus:ring-blue-400"
          required
        />
      </div>

      <!-- Description -->
      <div>
        <label for="description" class="block text-sm font-medium text-gray-700 mb-1">Description</label>
        <textarea
          id="description"
          name="description"
          placeholder="Task description"
          class="border rounded p-2 w-full h-32 resize-none focus:outline-none focus:ring-2 focus:ring-blue-400"
        ><%= @task && @task["description"] %></textarea>
      </div>

      <!-- Assignee (only in edit mode) -->
      <%= if @action == "edit" do %>
        <div>
          <label for="assignee_id" class="block text-sm font-medium text-gray-700 mb-1">Assigned User</label>
          <select name="assignee_id" id="assignee_id" class="border rounded p-2 w-full">
            <option value="">Unassigned</option>
            <%= for user <- @users do %>
              <option value={user["id"]} selected={@task["assignee_id"] == user["id"]}>
                <%= user["email"] %>
              </option>
            <% end %>
          </select>
        </div>
      <% end %>

      <!-- Buttons -->
      <div class="flex space-x-2 justify-end">
        <button
          type="submit"
          class="bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600"
        >
          Save
        </button>

        <button
          type="button"
          class="bg-gray-300 px-4 py-2 rounded hover:bg-gray-400"
          phx-click={cancel_event(@action)}
        >
          Cancel
        </button>
      </div>
    </form>
    """
  end

  # Private helpers

  defp form_event("create"), do: "create_task"
  defp form_event("edit"), do: "update_task"

  defp cancel_event("create"), do: "cancel_create_task"
  defp cancel_event("edit"), do: "cancel_edit"
end
