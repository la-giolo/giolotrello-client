defmodule GiolotrelloClientWeb.TaskCardComponent do
  use GiolotrelloClientWeb, :component

  def task_card(assigns) do
    ~H"""
    <li
      class="bg-white rounded p-2 shadow-sm cursor-pointer hover:bg-gray-50"
      data-id={@task["id"]}
      phx-click="show_task"
      phx-value-id={@task["id"]}
      phx-value-title={@task["title"]}
      phx-value-description={@task["description"]}
      phx-value-list-id={@task["id"]}
    >
      <strong><%= @task["title"] %></strong><br />
      <span class="text-sm text-gray-600"><%= @task["description"] %></span>
    </li>
    """
  end
end
