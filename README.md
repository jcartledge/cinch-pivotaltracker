# Cinch Pivotal Tracker plugin

This plugin provides [Pivotal Tracker](http://www.pivotaltracker.com) functionality for [Cinch](https://github.com/cinchrb/cinch) bots.

This is at a very early stage of development, is probably unstable and currently only supports a very limited set of read-only functionality. It may not be maintained.


## Installation

It's not published yet so if you want to use it you'll have to do so from source. Please heed the warning about maturity, stability and maintenance above.

Still here? Use bundler. Add the following (or similar) to your project `Gemfile`:

    gem "cinch-pivotaltracker", :git => "git://github.com/jcartledge/cinch-pivotaltracker.git"

Then use bundler to install it:

    $ bundle install

Then load it in your bot:

    require "cinch"
    require "cinch/plugins/pivotaltracker"

    bot = Cinch::Bot.new do
      configure do |c|
        # add all required options here
        c.plugins.plugins = [Cinch::Plugins::PivotalTracker] # optionally add more plugins
      end
    end

    bot.start


## Commands

All commands are prefixed by `!pt `.

### !pt help
display a helpful usage message

### !pt projects
list all projects

### !pt project
display the current project

### !pt project=[PROJECT\_ID]
change the current project

### !pt current
list all stories in the current iteration

### !pt bugs
list bugs in the current iteration

### !pt features
list features in the current iteration

### !pt chores
list chores in the current iteration

### !pt story [STORY\_ID]
display story details

## Options

### :token
Pivotal Tracker auth token. The plugin doesn't work very well if you don't specify this.

### :project_id
Commands like `current`, `bugs` etc work on a selected project which you can set with the `project` command. This option takes a Pivotal Tracker project ID and sets that as the initial selected project.

#### Example configuration

    configure do |c|
      ...
      c.plugins.options[Cinch::Plugins::PivotalTracker][:token] = ENV['token']
      c.plugins.options[Cinch::Plugins::PivotalTracker][:project_id] = ENV['project_id']
    end
