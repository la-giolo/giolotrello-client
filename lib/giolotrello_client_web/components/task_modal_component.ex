defmodule GiolotrelloClientWeb.TaskModalComponent do
  use GiolotrelloClientWeb, :live_component

  alias GiolotrelloClientWeb.{
    TaskFormComponent,
    TaskDetailsComponent,
    CommentListComponent,
    CommentFormComponent
  }

  @impl true
  def update(assigns, socket) do
    socket =
      socket
      |> assign_new(:creating_task, fn -> false end)
      |> assign_new(:editing_task, fn -> false end)
      |> assign_new(:task, fn -> nil end)
      |> assign_new(:users, fn -> [] end)
      |> assign_new(:comments, fn -> [] end)
      |> assign(assigns)

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="fixed inset-0 flex items-center justify-center bg-black/50 z-50">
      <div class="bg-white rounded-lg shadow-lg w-full max-w-4xl p-6">
        <%= case {@creating_task, @editing_task} do %>
          <% {true, _} -> %>
            <.live_component
              module={TaskFormComponent}
              id="new-task-form"
              action="create"
              users={@users}
              list_id={@list_id}
            />

          <% {_, true} -> %>
            <.live_component
              module={TaskFormComponent}
              id={"edit-task-form-#{@task["id"]}"}
              action="edit"
              task={@task}
              users={@users}
              list_id={@task["list_id"]}
            />

          <% _ -> %>
            <div class="flex space-x-6">
              <!-- Left side: Task Details -->
              <div class="w-1/2 border-r pr-4">
                <.live_component
                  module={TaskDetailsComponent}
                  id={"task-details-#{@task["id"]}"}
                  task={@task}
                  users={@users}
                />
              </div>

              <!-- Right side: Comments -->
              <div class="w-1/2 pl-4 flex flex-col">
                <div class="flex-1 overflow-y-auto">
                  <.live_component
                    module={CommentListComponent}
                    id={"comments-#{@task["id"]}"}
                    comments={@comments}
                  />
                </div>

                <div class="mt-4">
                  <.live_component
                    module={CommentFormComponent}
                    id={"comment-form-#{@task["id"]}"}
                    task_id={@task["id"]}
                  />
                </div>
              </div>
            </div>
        <% end %>
      </div>
    </div>
    """
  end
end
