defmodule Discuss.AuthController do
    use Discuss.Web, :controller
    plug Ueberauth

    alias Discuss.User
    
#   This function will be called whenever we get redirected back from github
#   This assigns property is what contains some customer information that the ueberauth module has added
#   
    def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
        IO.inspect(auth)
        user_params = %{token: auth.credentials.token, email: auth.info.email, provider: "github"}
        changeset = User.changeset(%User{}, user_params)

        signin(conn, changeset)
    #   IO.puts "+++++"
    #   IO.inspect(conn.assigns)
    #   IO.puts "+++++"
    #   IO.inspect(params)
    #   IO.puts "+++++"
    end

    def signout(conn, _params) do
        conn
        # Whatever we have any session, drop it
        |> configure_session(drop: true)
        |> redirect(to: topic_path(conn, :index))
    end

    defp signin(conn, changeset) do

        case insert_or_update_user(changeset) do
            {:ok, user} -> 
                conn
                |> put_flash(:info, "welcome back!")
                |> put_session(:user_id, user.id)
                |> redirect(to: topic_path(conn, :index))
                
            {:error, _reason} ->
                conn
                |> put_flash(:error, "error Signing in")
                |> redirect(to: topic_path(conn, :index))
        end
        
    end
    
# defp stands for private
    defp insert_or_update_user(changeset) do
        case Repo.get_by(User, email: changeset.changes.email) do
            nil ->
                Repo.insert(changeset)
            user ->
                {:ok, user}
        end

    end
    
end