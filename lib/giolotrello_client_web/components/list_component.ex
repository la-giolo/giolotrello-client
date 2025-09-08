defmodule GiolotrelloClientWeb.ListComponent do
  use GiolotrelloClientWeb, :live_component

  alias GiolotrelloClientWeb.TaskComponent

  def render(assigns) do
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

      <ul
        class="space-y-2"
        id={"tasks#{@list["id"]}"}
        phx-hook="SortableTasks"
        data-list-id={@list["id"]}
      >
        <%= for task <- @list["tasks"] do %>
          <.live_component
            module={TaskComponent}
            id={"task-#{task["id"]}"}
            task={task}
          />
        <% end %>
      </ul>

      <button
        class="text-blue-600 hover:underline text-sm"
        phx-click="new_task"
        phx-value-list_id={@list["id"]}
      >
        + Add Task
      </button>

      <div class="mt-3">
        <form phx-submit="add_user_to_list">
          <input type="hidden" name="list_id" value={@list["id"]} />

          <select
            name="user_id"
            class="border rounded px-2 py-1 text-sm"
          >
            <option value="">-- Add User --</option>
            <%= for user <- @all_users do %>
              <option value={user["id"]}><%= user["email"] %></option>
            <% end %>
          </select>

          <button
            type="submit"
            class="mt-2 w-full bg-blue-600 text-white px-3 py-1 rounded text-sm hover:bg-blue-700"
          >
            Add User
          </button>
        </form>
      </div>
    </div>
    """
  end
end
