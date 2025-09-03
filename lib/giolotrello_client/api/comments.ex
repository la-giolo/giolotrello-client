defmodule GiolotrelloClient.API.Comments do
  alias GiolotrelloClient.API.Client
  alias GiolotrelloClient.Helpers.ApiHelper

  def create_comment(task_id, body, token) do
    headers = ApiHelper.bearer(token)
    body = %{comment: %{body: body}}

    Client.post("/tasks/#{task_id}/comments", body, headers: headers)
  end
end
