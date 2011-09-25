# Cinch Pivotal Tracker plugin

This plugin provides [Pivotal Tracker](http://www.pivotaltracker.com) functionality for [Cinch](https://github.com/cinchrb/cinch) bots.

This is at a very early stage of development, is probably unstable and currently only supports a very limited set of read-only functionality.

## Installation

Use bundler. Add the following (or similar) to your Gemfile:

    gem "cinch-pivotaltracker"

Then use bundler to install it:

    $ bundle install

Then load it in your bot:

    require "cinch"
    require "cinch/plugins/cinch-pivotaltracker"

    bot = Cinch::Bot.new do
      configure do |c|
        # add all required options here
        c.plugins.plugins = [Cinch::Plugins::CinchPivotalTracker] # optionally add more plugins
      end
    end

    bot.start


## Commands

All commands are prefixed by `!pt`. Check the source, or run your bot and try `!pt help`.

## Options

### :token
Pivotal Tracker auth token. The plugin doesn't work very well if you don't specify this.

### :project_id
Commands like `current`, `bugs` etc work on a selected project which you can set with the `project` command. This option takes a Pivotal Tracker project ID and sets that as the initial selected project.

### Example configuration

    configure do |c|
      ...
      c.plugins.options[Cinch::Plugins::CinchPivotalTracker][:token] = ENV['token']
      c.plugins.options[Cinch::Plugins::CinchPivotalTracker][:project_id] = ENV['project_id']
    end
