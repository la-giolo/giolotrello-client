defmodule GiolotrelloClientWeb.TaskModalComponent do
  use GiolotrelloClientWeb, :live_component

  @impl true
  def update(assigns, socket) do
    socket =
      socket
      |> assign_new(:creating_task, fn -> false end)
      |> assign_new(:editing_task, fn -> false end)
      |> assign_new(:comments, fn -> [] end)
      |> assign(assigns)

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="fixed inset-0 z-50 flex items-center justify-center">
      <div class="absolute inset-0 bg-black/50" phx-click="close_task"></div>

      <div class="relative bg-white rounded-lg shadow-lg p-6 w-[700px] flex">
        <!-- Left side: task details -->
        <div class="flex-1 pr-6">
          <button
            class="absolute top-2 right-2 text-gray-500 hover:text-gray-700"
            phx-click="close_task"
          >
            ✕
          </button>

          <%= case {@creating_task, @editing_task} do %>
            <% {true, _} -> %>
              <!-- Create form -->
              <form phx-submit="create_task">
                <input type="hidden" name="list_id" value={@list_id} />
                <input type="text" name="title" placeholder="Task title" />
                <textarea name="description" placeholder="Description"></textarea>
                <button type="submit">Save</button>
                <button type="button" phx-click="cancel_create_task">Cancel</button>
              </form>

            <% {_, true} -> %>
              <!-- Edit form -->
              <form phx-submit="update_task">
                <input type="hidden" name="task_id" value={@task["id"]} />
                <input type="text" name="title" value={@task["title"]} class="border rounded p-1 w-full mb-2" />
                <textarea name="description" class="border rounded p-1 w-full mb-2"><%= @task["description"] %></textarea>

                <div class="flex space-x-2">
                  <button type="submit" class="bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600">Save</button>
                  <button type="button" class="bg-gray-300 px-4 py-2 rounded hover:bg-gray-400" phx-click="cancel_edit">Cancel</button>
                </div>
              </form>

            <% _ -> %>
              <!-- Show task -->
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

        <!-- Right side: comments -->
        <div class="w-64 border-l pl-4 flex flex-col">
          <h3 class="font-semibold mb-2">Comments</h3>

          <div class="flex-1 overflow-y-auto space-y-2">
            <%= for comment <- @task["comments"] || [] do %>
              <div class="border rounded p-2 text-sm bg-gray-50">
                <p><%= comment["body"] %></p>
              </div>
            <% end %>
          </div>

          <form phx-submit="add_comment" class="flex flex-col space-y-2">
            <input type="hidden" name="task_id" value={@task["id"]} />
            <textarea
              name="body"
              placeholder="Write a comment..."
              class="border rounded p-2 w-full resize-none"
            ></textarea>
            <button type="submit" class="bg-blue-500 text-white px-3 py-1 rounded hover:bg-blue-600 self-end">
              Add Comment
            </button>
          </form>
        </div>
      </div>
    </div>
    """
  end

end
