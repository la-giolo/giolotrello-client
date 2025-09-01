defmodule GiolotrelloClientWeb.TaskListComponent do
  use GiolotrelloClientWeb, :component

  import GiolotrelloClientWeb.TaskCardComponent

  def task_list(assigns) do
    ~H"""
    <div class="bg-gray-100 rounded-lg p-4 w-64 shadow">
      <div class="flex justify-between items-center mb-2">
        <h2 class="font-semibold text-lg"><%= @list["title"] %></h2>
        <button
          class="text-red-500 hover:text-red-700 text-sm"
          phx-click="delete_list"
          phx-value-id={@list["id"]}
        >
          ✖
        </button>
      </div>

      <ul class="space-y-2" id="task" phx-hook="SortableTasks">
        <%= for task <- @list["tasks"] do %>
          <.task_card task={task} />
        <% end %>
      </ul>

      <button
        class="text-blue-600 hover:underline text-sm"
        phx-click="new_task"
        phx-value-list_id={@list["id"]}
      >
        + Add Task
      </button>
    </div>
    """
  end
end
