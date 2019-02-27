defmodule Discuss.CommentsChannel do
    use Discuss.Web, :channel
# whenever a javacsript client attempts to join this channel
    def join(name, _params, socket) do
        
        IO.puts("+++++")
        IO.puts(name)
        {:ok, %{hey: "there"}, socket}
    end
    # clicking on forms etc
    def handle_in(name, message, socket) do
        IO.puts("++++")
        IO.puts(name)
        IO.inspect(message)

        
        {:reply, :ok, socket}

    end
    
end