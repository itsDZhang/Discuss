defmodule Discuss.Repo.Migrations.AddUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
        add :email, :string
        add :provider, :string
        add :token, :string 
        # this method will make sure every user has a created at and last modified property
        timestamps()

        
    end

  end
end
