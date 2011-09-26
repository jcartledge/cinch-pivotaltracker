require 'spec_helper'

module Cinch::Plugins::PivotalTracker::Spec
  def setup
    # useful structs
    Struct.new("Project", :name, :id)

    # mock out bot and user
    options = mock('options')
    options.stub(:[])

    plugins = mock('plugins')
    plugins.stub(:suffix)
    plugins.stub(:options).and_return(options)

    config = mock('config')
    config.stub(:plugins).and_return(plugins)

    @bot = mock('bot')
    @bot.stub(:debug)
    @bot.stub(:on)
    @bot.stub(:options).and_return(config)
    @bot.stub(:config).and_return(config)

    @user = mock('user')
  end
end

describe Cinch::Plugins::PivotalTracker, "projects" do
  include Cinch::Plugins::PivotalTracker::Spec

  before do
    setup

    # stub PT response
    ::PivotalTracker::Project.should_receive(:all).and_return([
      Struct::Project.new("Test project 1", 1),
      Struct::Project.new("Test project 2", 2),
    ])
  end

  it "should list all projects" do
    @user.should_receive(:reply).with('Test project 1: 1')
    @user.should_receive(:reply).with('Test project 2: 2')

    plugin = Cinch::Plugins::PivotalTracker.new(@bot)
    plugin.projects(@user)
  end
end

describe Cinch::Plugins::PivotalTracker, "project=" do
  it "should set the current project" do
    pending
  end
  it "should fail when the project doesn't exist" do
    pending
  end
end

describe Cinch::Plugins::PivotalTracker, "project" do
  it "should display the name of the current project" do
    pending
  end
end

describe Cinch::Plugins::PivotalTracker, "current" do
  it "should list all stories in the current iteration" do
    pending
  end
end

describe Cinch::Plugins::PivotalTracker, "features" do
  it "should list all features in the current iteration" do
    pending
  end
end

describe Cinch::Plugins::PivotalTracker, "bugs" do
  it "should list all bugs in the current iteration" do
    pending
  end
end

describe Cinch::Plugins::PivotalTracker, "chores" do
  it "should list all chores in the current iteration" do
    pending
  end
end

describe Cinch::Plugins::PivotalTracker, "story" do
  it "should show details of a story" do
    pending
  end
  it "should fail if the story doesn't exist" do
    pending
  end
end
