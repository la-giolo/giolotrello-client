defmodule GiolotrelloClientWeb.TaskModalComponent do
  use GiolotrelloClientWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="fixed inset-0 bg-gray-100 bg-opacity-50 flex items-center justify-center z-50">
      <div class="bg-white rounded-lg shadow-lg p-6 w-96 relative">
        <button
          class="absolute top-2 right-2 text-gray-500 hover:text-gray-700"
          phx-click="close_task"
        >
          ✕
        </button>

        <%= if @editing_task do %>
          <form phx-submit="update_task">
            <input type="hidden" name="task_id" value={@task["id"]} />
            <input type="text" name="title" value={@task["title"]} class="border rounded p-1 w-full mb-2" />
            <textarea name="description" class="border rounded p-1 w-full mb-2"><%= @task["description"] %></textarea>

            <div class="flex space-x-2">
              <button type="submit" class="bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600">Save</button>
              <button type="button" class="bg-gray-300 px-4 py-2 rounded hover:bg-gray-400" phx-click="cancel_edit">Cancel</button>
            </div>
          </form>
        <% else %>
          <h2 class="text-xl font-bold mb-4"><%= @task["title"] %></h2>
          <p class="text-gray-700 mb-4"><%= @task["description"] %></p>
          <div class="flex space-x-2">
            <button
              class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600"
              phx-click="edit_task"
              phx-value-id={@task["id"]}
            >
              Edit
            </button>
            <button
              class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600"
              phx-click="delete_task"
              phx-value-id={@task["id"]}
            >
              Delete
            </button>
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end
