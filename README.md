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

![Image](../master/tutorial/resources/step4.gif?raw=true)

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




And now let's change `reply(msg, msg.body)` to Broadcasting on




