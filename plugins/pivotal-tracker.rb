require 'cinch'
require 'pivotal-tracker'


class PivotalTrackerPlugin
  include Cinch::Plugin

  prefix "pt "
  match /projects/,       method: :projects
  match /project$/,       method: :project
  match /project (\d+)/,  method: :set_project
  match /search (.+)/,    method: :search


  def initialize bot
    PivotalTracker::Client.token = 'ef43948f44e659e2e6a263dfab9e8e0a'
    @project = PivotalTracker::Project.find('73418')
    super(bot)
  end

  def projects(m)
    projects = PivotalTracker::Project.all
    reply = "Projects:\r"
    projects.each do |project|
      reply += "#{project.name}: #{project.id}\r"
    end
    m.reply reply
  end

  def project(m)
    m.reply "Current project is #{@project.name}: #{@project.id}"
  end

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


  def search(m, query)
    m.reply "Sorry, nothing found for #{foo}"
  end
end
