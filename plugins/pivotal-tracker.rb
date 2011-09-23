require 'cinch'
require 'pivotal-tracker'

class PivotalTrackerPlugin
  include Cinch::Plugin

  prefix "!pt"

  match " help",                  method: :help

  match /\stoken\s*=?\s*(.+)/,    method: :token=
  match " projects",              method: :projects
  match " project",               method: :project
  match /\sproject\s*=?\s*(\d+)/, method: :project=

  match " current",               method: :current
  match " bugs",                  method: :bugs
  match " features",              method: :features
  match " chores",                method: :chores

  match /\sstory (\d+)/,          method: :story

  # token and project_id can be supplied as environment variables
  def initialize bot
    token = ENV['token']
    if token
      self.set_token(token)
      @project = PivotalTracker::Project.find(ENV['project_id']) if ENV['project_id']
      super(bot)
    end
  end

  # display a helpful messsage about usage
  def help(m)
    m.reply "!pt help                 # display this message"

    m.reply "!pt token=[TOKEN_ID]     # set the Pivotal Tracker auth token"
    m.reply "!pt projects             # list projects"
    m.reply "!pt project              # display the current project"
    m.reply "!pt project=[PROJECT_ID] # change the current project"

    m.reply "!pt current              # list all stories in the current iteration"
    m.reply "!pt bugs                 # list bugs in the current iteration"
    m.reply "!pt features             # list features in the current iteration"
    m.reply "!pt chores               # list chores in the current iteration"

    m.reply "!pt story [STORY_ID]     # display story details"
  end

  # set the auth token
  def token=(m, token)
    self.set_token(token)
    m.reply "Token is now #{token}"
  end

  # list all projects
  def projects(m)
    begin
    PivotalTracker::Project.all.each do |project|
      m.reply "#{project.name}: #{project.id}"
    end
    rescue
      m.reply "Something went wrong :("
    end
  end

  # display the current project
  def project(m)
    m.reply "Current project is #{@project.name}: #{@project.id}"
  end

  # set the current project by id
  def project=(m, project_id)
    begin
      project = PivotalTracker::Project.find(project_id)
      m.reply "Current project is now #{@project.name}: #{@project.id}"
    rescue
      project = @project
      m.reply "Could not find project #{project_id} - project is still #{@project.name}"
    end
    @project = project
  end

  # list stories in the current iteration
  def current(m)
    current = @project.iteration(:current)
    days_left = (current.finish - Date.today).to_i - 1
    if days_left > 1
      m.reply "#{days_left} days left"
    elsif days_left == 1
      m.reply "1 day left"
    else
      m.reply "Finishes today"
    end
    current.stories.map do |story|
      show_story(m, story)
    end
  end

  def features(m)
    show_stories_by_type(m, @project.iteration(:current).stories, "feature")
  end

  def bugs(m)
    show_stories_by_type(m, @project.iteration(:current).stories, "bug")
  end

  def chores(m)
    show_stories_by_type(m, @project.iteration(:current).stories, "chore")
  end

  # show details of story by id
  def story(m, story_id)
    begin
      story = @project.stories.find(story_id)
      show_story(m, story)
      m.reply("Requested by #{story.requested_by}") if story.requested_by
      m.reply("Owned by #{story.owned_by}") if story.owned_by
      m.reply(story.description)
      m.reply(story.url)
    rescue
      m.reply "Couldn't find that story :("
    end
  end

  protected

  def set_token(token)
    PivotalTracker::Client.token = token
  end

  def show_story(m, story)
    estimate = ""
    estimate = ("*" * story.estimate) + " " if story.estimate
    m.reply "#{story.id} [#{story.story_type[0]}][#{story.current_state}] #{estimate}#{story.name}"
  end

  def show_stories_by_type(m, stories, type)
    stories.select{ |s|
      s.story_type == type
    }.map{ |story| show_story(m, story) }
  end

end
