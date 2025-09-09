defmodule GiolotrelloClientWeb.CommentListComponent do
  use GiolotrelloClientWeb, :live_component

  @impl true
  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="space-y-2 max-h-40 overflow-y-auto">
      <%= for comment <- @comments do %>
        <div class="p-2 bg-gray-100 rounded-lg">
          <p class="text-sm"><%= comment.body%></p>
          <span class="text-xs text-gray-500">— <%= comment.email %></span>
        </div>
      <% end %>
    </div>
    """
  end
end
