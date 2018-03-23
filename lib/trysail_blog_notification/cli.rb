# frozen_string_literal: true

module TrySailBlogNotification
  class Cli < Thor

    class_option 'log-level', desc: 'Set the logger level.', type: :string, enum: %w(fatal error warn info debug)

    package_name TrySailBlogNotification::Application::NAME

    desc 'start', 'Run trysail-blog-notification.'
    option 'no-notification', desc: 'No send the notification.', type: :boolean, default: false
    def start
      command = TrySailBlogNotification::Command::StartCommand.new(options, args)
      command.start
    end

    desc 'console', 'Start trysail-blog-notification console'
    def console
      command = TrySailBlogNotification::Command::ConsoleCommand.new(options, args)
      command.start
    end

    desc 'clean', 'Clean log and data files.'
    def clean
      command = TrySailBlogNotification::Command::CleanCommand.new(options, args)
      command.start
    end

    no_commands do

      def invoke_command(command, *args)
        app = TrySailBlogNotification::Application.app
        app.log.level = options['log-level'] unless options['log-level'].nil?

        super(command, *args)
      end

    end

  end
end