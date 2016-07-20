# mongoosetutorial

# Hands on XMPP(MongooseIM) connection from Phoenix/Elixir using Hedwig
Tutorial on making use of XMPP technology from a Phoenix server to provide realtime feed in a form of news ticker on our website.

## Preparation
To check if You have everything installed run

bash <(wget -qO- https://raw.githubusercontent.com/wende/mongoosetutorial/master/checkenv.sh)

In Your CLI. If there are no errors You can safely skip this part and move to [Preparing the project](#preparing-the-project)

### Installing MongooseIM




First You need to head to [MongooseIM's repo download section](https://github.com/esl/MongooseIM#download-packages) and download distribution matching Your operating system. It's best to download latest stable version (by the time this tutorial is written it's 1.5.1 rev. 2)

To check if the instalation completed properly open the command-line and insert `mongooseimctl status`. If the terminal responded with `The node mongooseim@localhost is started with status: started` then It's alright and we're good to go.

### Installing Phoenix
If You haven't got Phoenix installed yet, head to the Phoenix's installation guide [here](http://www.phoenixframework.org/docs/installation).

### Preparing the project

Now let's create the project. If You already have an existing project You can skip this section.

Type in the commandline the universal bootstrapping command for Phoenix projects

mix phoenix.new project_name

We'll use `mongoosetutorial` name for the sake of this tutorial.

![Image](https://raw.githubusercontent.com/wende/mongoosetutorial/master/tutorial/resources/step1.gif?raw=true)

Now let's open our newly created project in our favorite IDE or text editor. I use emacs with alchemist-mode but any other text-editor will do just fine.

For the sake of making sure everythin works fine let's start the server in the commandline and do a safety check.

cd mongoosetest/
mix phoenix.server

And check if everything is alright by going to localhost:4000

We should see something like that:
![Image](https://raw.githubusercontent.com/wende/mongoosetutorial/master/tutorial/resources/step3.png?raw=true)

And the server should output something similiar to that:
![Image](https://raw.githubusercontent.com/wende/mongoosetutorial/master/tutorial/resources/step2.gif?raw=true)

Now we need to include some XMPP client to be able to talk to MongooseIM.
We're gonna use [scrogson/hedwig](https://github.com/scrogson/hedwig) for that.
Let's add

{:hedwig, "~> 0.1.0"},
{:exml, github: "paulgray/exml"}

to our deps in mix.exs
and also `, :hedwig, :exml` to `applications`

![Image](https://raw.githubusercontent.com/wende/mongoosetutorial/master/tutorial/resources/step4.gif?raw=true)
![Image](https://raw.githubusercontent.com/wende/mongoosetutorial/master/tutorial/resources/step4.1.gif?raw=true)

Now let's download all new deps with

mix deps.get

![Image](https://raw.githubusercontent.com/wende/mongoosetutorial/master/tutorial/resources/step5.gif?raw=true)

### XMPP Client

First we need to configure the XMPP client for it to run properly. Let's open `config/config.exs` and paste that at the end of the file
```elixir
# mongoosetutorial/config/config.exs

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
 handlers: [{Mongoosetutorial.Handlers.Echo, %{}}]
 }]
```

Now let's create our first Hedwig handler. Handler is a module specifying what we would like to do with each incoming XMPP Stanza.

Let's paste the echo handler

```elixir
# mongoosetutorial/lib/handlers/echo_handler.ex

defmodule Mongoosetutorial.Handlers.Echo do

@usage nil

use Hedwig.Handler

def handle_event(%Message{} = msg, opts) do
reply(msg, msg.body)
{:ok, opts}
end

def handle_event(_, opts), do: {:ok, opts}
end
```

![Image](https://raw.githubusercontent.com/wende/mongoosetutorial/master/tutorial/resources/step7.gif?raw=true)


Now we need to make the browser connect to our server via WebSockets
We're going to use an abstraction called [Channels](http://www.phoenixframework.org/docs/channels)

Let's open `web/channels/user_socket` (If You don't have this file You need to update Your Phoenix to the newest version and start all over again from [Preparing the project](#preparing-the-project))
And uncomment the line ( #5 in my version)
`# channel "rooms:*", Mongoosetutorial.RoomChannel `

![Image](https://raw.githubusercontent.com/wende/mongoosetutorial/master/tutorial/resources/step8.gif?raw=true)

Let's also uncomment
`import socket from "./socket"`
from `web/static/js/app.js`

No we can do a safety check. Start the server with `mix phoenix.server` and open the browser on `localhost:4000`. Open the JavaScript console and check if there's `Unabled to join Object {reason: "unmatched topic"}` if there then everything is as it should be.

Now we need to create a RoomChannel.
Let's create a file `web/channels/room_channel.ex` and paste that inside
```elixir
#mongoosetutorial/web/channels/room_channel.ex

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

![Image](https://raw.githubusercontent.com/wende/mongoosetutorial/master/tutorial/resources/step9.gif?raw=true)

Now we need to modify the client. Let's change the room in the `web/channels/socket.js` to `rooms:lobby`

![Image](https://raw.githubusercontent.com/wende/mongoosetutorial/master/tutorial/resources/step10.gif?raw=true)

Now let's verify that we did everything correct:
Head to:
http://localhost:4000/
Open developers console and You should see something like that:
![Image](https://raw.githubusercontent.com/wende/mongoosetutorial/master/tutorial/resources/safety-check.png?raw=true)

Now let's do something fancy with it

First let's init `alert-info` div to contain badass marquee tag (Because we can)
Now we're gonna add a handler for incoming messages.
Let's add a `on("message")` handler and when it executes we will append message content to our alert-info div.
I've also added that the messages are capped at length of 3, so that we don't get overloaded with them with time/
```js
// mongoosetutorial/web/static/js/socket.js

var news = [];
document.querySelector(".alert-info").innerHTML = "<marquee> </marquee>";
var show = function(info){
news.push(info);
if(news.length > 3) news.shift();
document.querySelector(".alert-info marquee").innerHTML = news.join(" | ");
};
channel.on("message", (msg)=> {
           show(msg.msg);
           });
```
![Image](https://raw.githubusercontent.com/wende/mongoosetutorial/master/tutorial/resources/step15.gif?raw=true)

And now let's go back to our EchoHandler and change `reply(msg, msg.body)` to Broadcasting on our Socket Endpoint.

Mongoosetutorial.Endpoint.broadcast! "rooms:lobby", "message", %{ :msg => msg.body}
![Image](https://raw.githubusercontent.com/wende/mongoosetutorial/master/tutorial/resources/step12.gif?raw=true)


You need to modify the credentials according to Your account. If You're running MongooseIM locally You can leave the credentials as they are, but remember to create such account on your machine with
`$ mongooseimctl register test localhost test` command at Your local machine.

If You've done that now let's open some XMPP client (I use Gajim) connect so some account and write a message to client under JID `test@localhost`

![Image](https://raw.githubusercontent.com/wende/mongoosetutorial/master/tutorial/resources/step14.png?raw=true)

Congratz! We just received our first XMPP Message with our primitive client.

The only problem right now is that whenever we refresh our website, all of our data gets wiped out.
So our last step will be adding a persistancy.

So let's use Agents to hold our state

```Elixir
# mongoosetutorial/lib/handlers/echo_handler.ex

def init(opts) do
Agent.start_link fn -> [] end, name: :news_ticker
{:ok, opts}
end
```

![Image](https://raw.githubusercontent.com/wende/mongoosetutorial/master/tutorial/resources/step16.gif?raw=true)

Now let's save last 3 messages

```Elixir
# mongoosetutorial/lib/handlers/echo_handler.ex

def handle_event(%Message{} = msg, opts) do
Agent.update :news_ticker, fn state ->
[msg | state] |> Enum.take(3)
end
Mongoosetutorial.Endpoint.broadcast! "rooms:lobby", "message", %{ :msg => msg.body}
{:ok, opts}
end
```
![Image](https://raw.githubusercontent.com/wende/mongoosetutorial/master/tutorial/resources/step17.gif?raw=true)

And send them when the client connects.
Because we can't yet push to the socket when it is initializing, we need to send it to our handler and handle that in handle_info.


```Elixir
# mongoosetutorial/web/channels/room_channel.ex

def join("rooms:lobby", auth_msg, socket) do
Kernel.send(self(), {:msgs, Agent.get(:news_ticker, &(&1))})
{:ok, socket}
end
```
```Elixir
# mongoosetutorial/web/channels/room_channel.ex

def handle_info({:msgs, msgs}, socket) do
Enum.reverse(msgs)
|> Enum.each(fn a -> push(socket, "message", %{"msg"=> a.body}) end)
{:noreply, socket}
end
```

![Image](https://raw.githubusercontent.com/wende/mongoosetutorial/master/tutorial/resources/step18.gif?raw=true)
![Image](https://raw.githubusercontent.com/wende/mongoosetutorial/master/tutorial/resources/step19.gif?raw=true)

Let's restart the server.
Send 3 messages again, and try to refresh the page.


![Image](https://raw.githubusercontent.com/wende/mongoosetutorial/master/tutorial/resources/step20.png?raw=true)


## Bonus - Release
To make a standalone release we need to open mix.exs and add

```elixir
{:exrm, "~> 0.15.3"}
```

and `server: true` to prod.exs configuration so it looks like

```elixir
config :mongoosetutorial, Mongoosetutorial.Endpoint,
http: [port: 4001],
url: [host: "example.com", port: 80],
cache_static_manifest: "priv/static/manifest.json",
server: true
```

To our dependecies.
Then we call commands in this order

```
  mix deps.get
  mix compile
  MIX_ENV=prod mix digest
  MIX_ENV=prod mix release
```
