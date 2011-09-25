# Cinch Pivotal Tracker plugin

This plugin provides [Pivotal Tracker](http://www.pivotaltracker.com) functionality for Cinch bots.

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
        c.plugins.plugins = [Cinch::Plugins::CinchPivotaltracker] # optionally add more plugins
      end
    end

    bot.start

Specify your Pivotal Tracker auth token as an environment variable:

    $ pivotaltracker_token=$MYTOKEN bundle exec ruby mybot.rb

## Commands

All commands are prefixed by `!pt`. Check the source, or run your bot and try `!pt help`.

