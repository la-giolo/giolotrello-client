defmodule GiolotrelloClientWeb.CommentFormComponent do
  use GiolotrelloClientWeb, :live_component

  @impl true
  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <form phx-submit="add_comment" phx-target={@myself} class="mt-3 flex space-x-2">
      <input
        type="text"
        name="content"
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
