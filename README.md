# mongoosetutorial

# Using XMPP (MongooseIM) Server with Elixir and Phoenix Framework

## Preparation
### Installing MongooseIM
First You need to head to [MongooseIM's repo download section](https://github.com/esl/MongooseIM#download-packages) and download distribution matching Your operating system. It's best to download latest stable version (by the time this tutorial is written it's 1.5.1 rev. 2)

To check if the instalation completed properly open the command-line and insert `mongooseimctl start`. If terminal responded with `Node is already running!` then It's alright and we're good to go.

### Installing Phoenix
If You haven't got Phoenix installed yet, head to the Phoenix's installation guide [here](http://www.phoenixframework.org/docs/installation).

### Creating the project

Now let's create the project. If You already have an existing project You can skip this section.

Type in the commandline the universal bootstrapping command for Phoenix projects

    mix phonix.new project_name

We'll use `mongoosetutorial` name for the sake of this tutorial.

![Image](../blob/master/tutorial/resources/last-session.gif?raw=true)
