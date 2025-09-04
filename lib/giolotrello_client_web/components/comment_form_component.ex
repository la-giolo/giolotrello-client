defmodule GiolotrelloClientWeb.CommentFormComponent do
  use GiolotrelloClientWeb, :live_component

  @impl true
  def update(assigns, socket) do
    socket =
      socket
      |> assign_new(:body, fn -> "" end)
      |> assign(assigns)

    {:ok, socket}
  end


  @impl true
  def render(assigns) do
    ~H"""
    <form phx-submit="add_comment" class="mt-3 flex space-x-2">
      <input type="hidden" name="task_id" value={@task_id} />

      <input
        type="text"
        name="body"
        value={@body}
        placeholder="Write a comment..."
        class="flex-grow px-2 py-1 border rounded text-sm"
      />
      <button
        type="submit"
        class="bg-blue-600 text-white px-3 py-1 rounded text-sm"
      >
        Post
      </button>
    </form>
    """
  end
end
