require 'cinch'
require 'pivotal-tracker'

class PivotalTrackerPlugin
  include Cinch::Plugin

  prefix "pt "
  match /token (.+)/,     method: :token
  match /projects/,       method: :projects
  match /project$/,       method: :project
  match /project (\d+)/,  method: :set_project
  match /search (.+)/,    method: :search

  # token and project_id can be supplied as environment variables
  def initialize bot
    token = ENV['token']
    if token
      self.set_token(token)
      @project = PivotalTracker::Project.find(ENV['project_id']) if ENV['project_id']
      super(bot)
    end
  end

  # set the auth token
  def token(m, token)
    self.set_token(token)
  end

  # list all projects
  def projects(m)
    PivotalTracker::Project.all.each do |project|
      m.reply "#{project.name}: #{project.id}\r"
    end
  end

  # display the current project
  def project(m)
    m.reply "Current project is #{@project.name}: #{@project.id}"
  end

  # set the current project by id
  # @TODO allow set by name
  def set_project(m, project_id)
    begin
      project = PivotalTracker::Project.find(project_id)
      m.reply "Current project is now #{@project.name}: #{@project.id}"
    rescue
      project = @project
      m.reply "Could not find project #{project_id} - project is still #{@project.name}"
    end
    @project = project
  end


  # search stories in the current project
  # @TODO implement
  def search(m, query)
    m.reply "Sorry, nothing found for #{foo}"
  end

  protected

  def set_token(token)
    PivotalTracker::Client.token = token
  end

end
