 defmodule Discuss.Router do
  use Discuss.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Discuss.Plugs.SetUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

#   Scope is to name space all urls
  scope "/", Discuss do
    pipe_through :browser # Use the default browser stack

    get "/", TopicController, :index

    # :new -> function "new"
    # Once the request has been sent,
    # it'll go to the TopicController 
    # Within the controller file, will be a function
    # called new

    # get "/topics/new", TopicController, :new 

    # post "/topics", TopicController, :create
    # get "/topics/:id/edit", TopicController, :edit
    # put "/topics/:id", TopicController, :update
    # The above is the same as the code below
    resources "/", TopicController


  end

  scope "/auth", Discuss do
    # Pipethrough is like, before any scope, do some preprocessing on the request
    pipe_through :browser
    get "/signout", AuthController, :signout
    # Making this dynamic now 
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end
    

  # Other scopes may use custom stacks.
  # scope "/api", Discuss do
  #   pipe_through :api
  # end
end
