defmodule GiolotrelloClient.Comments.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :integer, autogenerate: false}

  schema "comments" do
    field :body, :string
    field :email, :string
    field :task_id, :integer
    field :user_id, :integer
  end

  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:id, :body, :email, :task_id, :user_id])
    |> validate_required([:body, :task_id])
    |> validate_length(:body, max: 10)
  end
end
