defmodule Discuss.Topic do
    use Discuss.Web, :model

    schema "topics" do
        field :title, :string
    end
# params \\ %{} => this is how we make a default parameter 
# if we ever pass in nil, it'll automatically change to %{} 
    def changeset(struct, params \\ %{}) do
        struct 
        |> cast(params,[:title])
        |> validate_required([:title])
        
    end
end