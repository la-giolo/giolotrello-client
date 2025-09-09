defmodule GiolotrelloClient.API.Comments do
  alias GiolotrelloClient.API.Client
  alias GiolotrelloClient.Helpers.ApiHelper
  alias GiolotrelloClient.Comments.Comment

  def get_comments(task_id, token) do
    headers = ApiHelper.bearer(token)

    case Client.get("/tasks/#{task_id}/comments", headers: headers) do
      {:ok, %Tesla.Env{status: 200, body: %{"data" => comments}}} ->
        {:ok, Enum.map(comments, &to_comment_struct/1)}

      {:ok, %Tesla.Env{} = env} ->
        {:error, {:unexpected_response, env.status, env.body}}

      {:error, reason} ->
        {:error, reason}
    end
  end

  def create_comment(task_id, body, token) do
    headers = ApiHelper.bearer(token)
    body = %{comment: %{body: body}}

    case Client.post("/tasks/#{task_id}/comments", body, headers: headers) do
      {:ok, %Tesla.Env{status: 201, body: %{"data" => comment_json}}} ->
        {:ok, to_comment_struct(comment_json)}

      {:ok, %Tesla.Env{} = env} ->
        {:error, {:unexpected_response, env.status, env.body}}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp to_comment_struct(%{"id" => id} = attrs) do
    %Comment{
      id: id,
      body: attrs["body"],
      email: attrs["email"],
      task_id: attrs["task_id"],
      user_id: attrs["user_id"]
    }
  end
end
