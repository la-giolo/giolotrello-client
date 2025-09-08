defmodule GiolotrelloClient.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :id, :integer
    field :title, :string
    field :description, :string
    field :position, :float
    field :list_id, :integer
    field :assignee_id, :integer
    field :inserted_at, :utc_datetime
    field :updated_at, :utc_datetime
  end

  def changeset(task, attrs) do
    task
    |> cast(attrs, [:id, :title, :description, :position, :list_id, :assignee_id, :inserted_at, :updated_at])
    |> validate_required([:title, :list_id])
    |> validate_length(:title, max: 255)
  end
end
