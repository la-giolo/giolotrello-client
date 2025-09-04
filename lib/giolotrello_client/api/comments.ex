defmodule GiolotrelloClient.API.Comments do
  alias GiolotrelloClient.API.Client
  alias GiolotrelloClient.Helpers.ApiHelper

  def get_comments(task_id, token) do
    headers = ApiHelper.bearer(token)

    Client.get("/tasks/#{task_id}/comments", headers: headers)
  end

  def create_comment(task_id, body, token) do
    headers = ApiHelper.bearer(token)
    body = %{comment: %{body: body}}

    Client.post("/tasks/#{task_id}/comments", body, headers: headers)
  end
end
