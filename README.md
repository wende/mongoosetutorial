# mongoosetutorial

# Using XMPP (MongooseIM) Server with Elixir and Phoenix Framework

## Preparation
### Installing MongooseIM
First You need to head to [MongooseIM's repo download section](https://github.com/esl/MongooseIM#download-packages) and download distribution matching Your operating system. It's best to download latest stable version (by the time this tutorial is written it's 1.5.1 rev. 2)

To check if the instalation completed properly open the command-line and insert `mongooseimctl start`. If terminal responded with `Node is already running!` then It's alright and we're good to go.

### Installing Phoenix
If You haven't got Phoenix installed yet, head to the Phoenix's installation guide [here](http://www.phoenixframework.org/docs/installation).

### Preparing the project

Now let's create the project. If You already have an existing project You can skip this section.

Type in the commandline the universal bootstrapping command for Phoenix projects

    mix phonix.new project_name

We'll use `mongoosetutorial` name for the sake of this tutorial.

![Image](../master/tutorial/resources/step1.gif?raw=true)

Now let's open our newly created project in our favorite IDE or text editor. I use emacs with alchemist-mode but any other text-editor will do just fine.

For the sake of making sure everythin works fine let's start the server in the commandline and do a safety check.

    mix phoenix.server
    
And check if everything is alright by going to localhost:3000

We should see something like that: 
![Image](../master/tutorial/resources/step3.png?raw=true)

And the server should output something similiar to that:
![Image](../master/tutorial/resources/step2.gif?raw=true)

Now we need to include some XMPP client to be able to talk to MongooseIM.
We're gonna use [scrogson/hedwig](https://github.com/scrogson/hedwig) for that.
Let's add 

    {:hedwig, "~> 0.1.0"},
    {:exml, github: "paulgray/exml"}
    
to our deps in mix.exs
and also `, :hedwig, :exml` to `applications`

![Image](../master/tutorial/resources/step4.gif?raw=true)
![Image](../master/tutorial/resources/step4.1.gif?raw=true)

Now let's download all new deps with 

    mix deps.get
    
![Image](../master/tutorial/resources/step5.gif?raw=true)

### XMPP Client

Now let's create our first Hedwig handler. Handler is a module specifying what we would like to do with each incoming XMPP Stanza.

Let's paste the echo handler

```elixir
defmodule Hedwig.Handlers.Echo do
  @moduledoc """
  A completely useless echo script.
  This script simply echoes the same message back.
  """
  
  @usage nil
  
  use Hedwig.Handler
  
  def handle_event(%Message{} = msg, opts) do
    reply(msg, msg.body)
    {:ok, opts}
  end
  
  def handle_event(_, opts), do: {:ok, opts}
end
```

![Image](../master/tutorial/resources/step7.gif?raw=true)


Now we need to make the browser connect to our server via WebSockets
We're going to use an abstraction called [Channels in Phoenix](http://www.phoenixframework.org/docs/channels)

Let's open `web/channels/user_socket` (If You don't have this file You need to update Your Phoenix to the newest version and start all over again from [Preparing the project](#preparing-the-project))
And uncomment the line ( #5 in my version) 
`# channel "rooms:*", Mongoosetutorial.RoomChannel `

![Image](../master/tutorial/resources/step8.gif?raw=true)

Let's also uncomment 
`import socket from "./socket"`
from `web/static/js/app.js`

No we can do a safety check. Start the server with `mix phoenix.server` and open the browser on `localhost:4000`. Open the JavaScript console and check if there's `Unabled to join Object {reason: "unmatched topic"}` if there then everything is as it should be.

Now we need to create a RoomChannel.
Let's create a file `web/channels/room_channel.ex` and paste that inside
```elixir
defmodule Mongoosetutorial.RoomChannel do
  use Phoenix.Channel
  
  def join("rooms:lobby", auth_msg, socket) do
    {:ok, socket}
  end
  def join("rooms:" <> _private_room_id, _auth_msg, socket) do
    {:error, %{reason: "unauthorized"}}
  end
  
end
``` 

![Image](../master/tutorial/resources/step9.gif?raw=true)

Now we need to modify the client. Let's change the room in the `web/channels/socket.js` to `rooms:lobby`

![Image](../master/tutorial/resources/step10.gif?raw=true)

Now we're gonna add a handler of incoming messages.
```js
channel.on("message", (msg)=> {               
    document.getElementsByClassName("jumbotron")[0].innerText = msg;             
}); 
```
    ![Image](../master/tutorial/resources/step11.gif?raw=true)

And now let's go back to our EchoHandler and change `reply(msg, msg.body)` to Broadcasting on our Socket Endpoint.

    Mongoosetutorial.Endpoint.broadcast! "rooms:lobby", "message", %{ :msg => msg.body}
![Image](../master/tutorial/resources/step12.gif?raw=true)


However this solution requires structure which can be easily cast to JSON, because of that we need to pass msg body as a map.
So let's sligthly correct our JS code written before.
![Image](../master/tutorial/resources/step13.gif?raw=true)


Because of that we also need to make a minor fix to  our socket.js code

![Image](../master/tutorial/resources/step13.gif?raw=true)


Now we need to configure the XMPP client for it to run properly. Let's open `config/config.exs` and paste that at the end of the file
```elixir
config :hedwig, :clients,         
   [%{
       jid: "test@localhost",
       password: "test",
       nickname: "test",
       rooms: [
         "test@localhost"      
       ],
      config: %{
        require_tls?: false,
        use_compression?: false,
            use_stream_management?: true,
            transport: :tcp
          },        
      handlers: [{Hedwig.Handlers.Echo, %{}}]       
}]
```

You need to modify the credentials according to Your account. If You're running MongooseIM locally You can leave the credentials as they are, but remember to create such account on your machine with 
`$ mongooseimctl register test localhost test` command at Your local machine.

If You've done that now let's open some XMPP client (I use Gajim) connect so some account and write a message to client under JID `test@localhost`

![Image](../master/tutorial/resources/step14.png?raw=true)

Congratz! We just received our first XMPP Message with our primitive client.
