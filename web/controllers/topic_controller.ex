defmodule  Discuss.TopicController do

    use Discuss.Web, :controller
    alias Discuss.Topic
# Guard clause
    plug Discuss.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete]

    plug :check_topic_owner when action in [:update, :edit, :delete]

    def index(conn, _params) do
        topics = Repo.all(Topic)
        # Make a topics property witha  list of topics 
        render conn, "index.html", topics: topics
    end
    
    def new(conn, _params) do
    # IO.inspect(conn.assigns)
        struct = %Topic{}
        params = %{}
        changeset = Topic.changeset(struct,params)
# `    Or we can do changeset = Topic.changeset(%Topic{}, %{})

#       We're passing in a keyword list
        render conn, "new.html", changeset: changeset
    end

    def show(conn, %{"id" => topic_id} ) do
    # Error will show if get! fails else it'll give nil to render and thus page crashes
        topic = Repo.get!(Topic, topic_id)
        render conn, "show.html", topic: topic

    end


    
    def create(conn, params) do
        # conn.assigns[:user]
        # conn.assigns.user

    
        #now we can access topic 
        %{"topic" => topic} = params
        changeset = Topic.changeset(%Topic{}, topic)

        changeset = conn.assigns.user
            |> build_assoc(:topics)
            |> Topic.changeset(topic)
        
        
        # Phoenix tries to stick the changeset into the database
        case Repo.insert(changeset) do
            {:ok, _topic } -> 
                conn
                # IO.inspect(post)
                |> put_flash(:info, "Topic Created")
                # Phoenix looks for a controller and then redirects to this topic path
                |> redirect(to: topic_path(conn, :index))

            {:error, changeset} -> 
                render conn, "new.html", changeset: changeset
        end         
        
    end

    def edit(conn, %{"id" => topic_id}) do
        topic = Repo.get(Topic, topic_id)
        changeset = Topic.changeset(topic)

        render conn, "edit.html", changeset: changeset, topic: topic
        
    end

    def update(conn, %{"id" => topic_id, "topic" => topic}) do
        old_topic = Repo.get(Topic, topic_id)
        changeset = Topic.changeset(old_topic, topic)
        # *** Top same as bottom one *****
        # changeset = Repo.get(Topic, topic_id) |> Topic.changeset(topic)

        case Repo.update(changeset) do
            {:ok, _topic} -> 
                conn
                |> put_flash(:info, "Topic Updated")
                |> redirect(to: topic_path(conn, :index))
            {:error, changeset } -> 
                render conn, "edit.html", changeset: changeset, topic: old_topic
                
        end
                
    end

    def delete(conn, %{"id" => topic_id }) do
        # delete! will return an error if anything goes wrong with the process
        Repo.get!(Topic, topic_id) |> Repo.delete!

        conn
        |> put_flash(:info, "Topic Deleted")        
        |> redirect(to: topic_path(conn, :index))
        
        
    end

    def check_topic_owner(conn, _params) do
        %{params: %{"id" => topic_id}} = conn

        if Repo.get(Topic, topic_id).user_id == conn.assigns.user.id do
            conn
        else 
            conn
            |> put_flash(:error, "You cannot edit")
            |> redirect(to: topic_path(conn, :index))
            |> halt()
        end

    end

    

end
