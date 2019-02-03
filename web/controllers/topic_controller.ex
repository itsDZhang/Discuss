defmodule  Discuss.TopicController do

    use Discuss.Web, :controller
    alias Discuss.Topic
    
    def new(conn, _params) do
        struct = %Topic{}
        params = %{}
        changeset = Topic.changeset(struct,params)
# `    Or we can do changeset = Topic.changeset(%Topic{}, %{})

#       We're passing in a keyword list
        render conn, "new.html", changeset: changeset
    end

    def index(conn, _params) do
        topics = Repo.all(Topic)
        # Make a topics property witha  list of topics 
        render conn, "index.html", topics: topics
    end

    
    def create(conn, params) do
        #now we can access topic 
        %{"topic" => topic} = params
        changeset = Topic.changeset(%Topic{}, topic)
        # Phoenix tries to stick the changeset into the database
        case Repo.insert(changeset) do
            {:ok, post } -> IO.inspect(post)
            {:error, changeset} -> 
                render conn, "new.html", changeset: changeset
        end         
        
    end

end