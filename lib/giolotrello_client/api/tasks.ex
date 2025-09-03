defmodule GiolotrelloClient.API.Tasks do
  alias GiolotrelloClient.API.Client
  alias GiolotrelloClient.Helpers.ApiHelper

  def create_task(params, token) do
    headers = ApiHelper.bearer(token)

    body = %{
      task: %{
        title: params["title"],
        description: params["description"],
        list_id: params["list_id"]
      }
    }

    Client.post("/tasks", body, headers: headers)
  end

  def update_task(task_id, params, token) do
    headers = ApiHelper.bearer(token)

    body = %{
      task: %{
        title: params["title"],
        description: params["description"],
        assignee_id: ApiHelper.normalize_assignee(params["assignee_id"])
      }
    }

    Client.put("/tasks/#{task_id}", body, headers: headers)
  end

  def reorder_task(task_id, params, token) do
    headers = ApiHelper.bearer(token)

    body = %{
      task: %{
        after_task_id: params["after_task_id"],
        list_id: params["list_id"]
      }
    }

    Client.put("/tasks/#{task_id}", body, headers: headers)
  end

  def delete_task(task_id, token) do
    headers = ApiHelper.bearer(token)

    Client.delete("/tasks/#{task_id}", headers: headers)
  end
end
