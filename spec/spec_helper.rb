require 'rubygems'
require 'bundler/setup'
require 'fakeweb'
require './lib/cinch/plugins/pivotaltracker'

Rspec.configure do |config|

  # the token, project id and fixtures are from the specs for the
  # Pivotal Tracker gem:
  # https://github.com/jsmestad/pivotal-tracker/tree/master/spec
  PROJECT_ID = ENV['PROJECT_ID'] || "102622"
  TOKEN = '8358666c5a593a3c82cda728c8a62b63'

  FakeWeb.allow_net_connect = false

  {
    "projects"          => "projects",
    "projects/" + TOKEN => "projects",
    "project/102622"    => "project"
  }.map do |url, filename|
    url = "http://www.pivotaltracker.com/services/v3/" + url
    open(File.dirname(__FILE__) + "/fixtures/" + filename + ".xml") do |f|
      body = f.read()
      FakeWeb.register_uri(:get, url,
        :body => body,
        :content_type => "application/xml")
    end
  end
end
