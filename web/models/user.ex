defmodule Discuss.User do
    use Discuss.Web, :model

    schema "users" do
        field :email, :string
        field :provider, :string
        field :token, :string
        has_many :topics, Discuss.Topic
        has_many :comments, Disucss.Comment
        
        timestamps()

    end
    # params \\ %{} will be an empty map if not defined
    def changeset(struct, params \\ %{}) do
        struct
        |> cast(params, [:email, :provider, :token])
        |> validate_required([:email, :provider, :token])
        
        
    end
    
end