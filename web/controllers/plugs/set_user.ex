defmodule Discuss.Plugs.SetUser do
    import Plug.Conn
    import Phoenix.Controller

    #The point of this plug is to
    # login to a session, grab the ID, fetch that user out of that
    # database and then we're going to transform on the connection object
    # and so any controller or plug in the future, we will have access
    # to user information and conn object on the user model

    alias Discuss.Repo
    alias Discuss.User
    alias Discuss.Router.Helpers


    def init(_params) do

    end
    # the _params is actually the return value from the above function
    def call(conn, _params) do
        user_id = get_session(conn, :user_id)

    # Condition statement
        cond do
        # If this thing returns a user and there's a user.id, this state will be truthy
        # If it is truthy, then Repo.get(...), it gets assigned to "user"
            user = user_id && Repo.get(User, user_id) ->
                assign(conn, :user, user)
                # conn.assigns.user => user struct            
            true ->
                assign(conn, :user, nil)
        end
        
    end
    
end