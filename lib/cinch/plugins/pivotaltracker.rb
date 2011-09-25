require 'cinch'
require 'pivotal-tracker'

module Cinch
  module Plugins
    class PivotalTracker
      include Cinch::Plugin

      prefix "!pt "

      match "help",                  method: :help

      match "projects",              method: :projects
      match "project",               method: :project
      match /project\s*=?\s*(\d+)/,  method: :project=

      match "current",               method: :current
      match "bugs",                  method: :bugs
      match "features",              method: :features
      match "chores",                method: :chores

      match /story (\d+)/,           method: :story

      def initialize bot, tracker=::PivotalTracker
        super(bot)
        @tracker = tracker
        set_token(config[:token])
        if config[:project_id]
          @project = @tracker::Project.find(config[:project_id])
        end
      end

      # display a helpful messsage about usage
      def help(user)
        user.reply "!pt help                 # display this message"

        user.reply "!pt projects             # list projects"
        user.reply "!pt project              # display the current project"
        user.reply "!pt project=[PROJECT_ID] # change the current project"

        user.reply "!pt current              # list all stories in the current iteration"
        user.reply "!pt bugs                 # list bugs in the current iteration"
        user.reply "!pt features             # list features in the current iteration"
        user.reply "!pt chores               # list chores in the current iteration"

        user.reply "!pt story [STORY_ID]     # display story details"
      end

      # list all projects
      def projects(user)
        begin
          @tracker::Project.all.each do |project|
            user.reply "#{project.name}: #{project.id}"
          end
        rescue
          user.reply "Something went wrong :("
        end
      end

      # display the current project
      def project(user)
        user.reply "Current project is #{@project.name}: #{@project.id}"
      end

      # set the current project by id
      def project=(user, project_id)
        begin
          project = @tracker::Project.find(project_id)
          user.reply "Current project is now #{@project.name}: #{@project.id}"
        rescue
          project = @project
          user.reply "Could not find project #{project_id} - project is still #{@project.name}"
        end
        @project = project
      end

      # list stories in the current iteration
      def current(user)
        current = @project.iteration(:current)
        days_left = (current.finish - Date.today).to_i - 1
        if days_left > 1
          user.reply "#{days_left} days left"
        elsif days_left == 1
          user.reply "1 day left"
        else
          user.reply "Finishes today"
        end
        current.stories.map do |story|
          show_story(user, story)
        end
      end

      def features(user)
        show_stories_by_type(user, @project.iteration(:current).stories, "feature")
      end

      def bugs(user)
        show_stories_by_type(user, @project.iteration(:current).stories, "bug")
      end

      def chores(user)
        show_stories_by_type(user, @project.iteration(:current).stories, "chore")
      end

      # show details of story by id
      def story(user, story_id)
        begin
          story = @project.stories.find(story_id)
          show_story(user, story)
          user.reply("Requested by #{story.requested_by}") if story.requested_by
          user.reply("Owned by #{story.owned_by}") if story.owned_by
          user.reply(story.description)
          user.reply(story.url)
        rescue
          user.reply "Couldn't find that story :("
        end
      end

      protected

      def set_token(token)
        @tracker::Client.token = token
      end

      def show_story(user, story)
        estimate = ""
        estimate = ("*" * story.estimate) + " " if story.estimate
        user.reply "#{story.id} [#{story.story_type[0]}][#{story.current_state}] #{estimate}#{story.name}"
      end

      def show_stories_by_type(user, stories, type)
        stories.select{ |s|
          s.story_type == type
        }.map{ |story| show_story(user, story) }
      end

    end

  end # module Plugins
end   # module Cinch
