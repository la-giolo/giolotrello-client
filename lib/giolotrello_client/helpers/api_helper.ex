defmodule GiolotrelloClient.Helpers.ApiHelper do
  def bearer(nil), do: []
  def bearer(""), do: []
  def bearer(token), do: [{"authorization", "Bearer #{token}"}]

  def normalize_assignee(""), do: nil
  def normalize_assignee(nil), do: nil
  def normalize_assignee(id) when is_binary(id), do: String.to_integer(id)
  def normalize_assignee(id), do: id
end
