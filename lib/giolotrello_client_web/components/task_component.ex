defmodule GiolotrelloClientWeb.TaskComponent do
  use GiolotrelloClientWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <li
      id={"task-#{@task["id"]}"}
      class="bg-white rounded p-2 shadow-sm cursor-pointer hover:bg-gray-50"
      phx-click="show_task"
      phx-value-id={@task["id"]}
    >
      <strong><%= @task["title"] %></strong><br />
      <span class="text-sm text-gray-600"><%= @task["description"] %></span>
    </li>
    """
  end
end
