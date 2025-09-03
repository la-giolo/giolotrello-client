defmodule GiolotrelloClient.Helpers.ApiHelper do
  def bearer(nil), do: []
  def bearer(""), do: []
  def bearer(token), do: [{"authorization", "Bearer #{token}"}]
end
