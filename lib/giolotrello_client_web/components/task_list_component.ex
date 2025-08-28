defmodule GiolotrelloClientWeb.TaskListComponent do
  use GiolotrelloClientWeb, :component

  import GiolotrelloClientWeb.TaskCardComponent

  def task_list(assigns) do
    ~H"""
    <div class="bg-gray-100 rounded-lg p-4 w-64 shadow">
      <h2 class="font-semibold text-lg mb-2"><%= @list["title"] %></h2>
      <ul class="space-y-2">
        <%= for task <- @list["tasks"] do %>
          <.task_card task={task} />
        <% end %>
      </ul>
    </div>
    """
  end
end
