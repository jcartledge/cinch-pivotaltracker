require 'cinch'
require './plugins/pivotal-tracker'

vubot = Cinch::Bot.new do
  configure do |c|
    c.server = '0.0.0.0'
    c.nick = 'vubot'
    c.channels = ['#vuwfg']
    c.plugins.plugins = [PivotalTrackerPlugin]
  end

end

vubot.start
