# frozen_string_literal: true

module TrySailBlogNotification
  class Cli < Thor

    class_option 'log-level', desc: 'Set the logger level.', type: :string, enum: %w(fatal error warn info debug)

    package_name TrySailBlogNotification::Application::NAME

    desc 'start', 'Run trysail-blog-notification.'
    option 'no-notification', desc: 'No send the notification.', type: :boolean, default: false
    def start
      call_command(TrySailBlogNotification::Command::StartCommand)
    end

    desc 'console', 'Start trysail-blog-notification console'
    def console
      call_command(TrySailBlogNotification::Command::ConsoleCommand)
    end

    desc 'clean', 'Clean log and data files.'
    option 'verbose', desc: 'Show verbose', type: :boolean, default: true
    option 'force', desc: 'Force remove', type: :boolean, default: false
    option 'noop', desc: 'Dry run', type: :boolean, default: false
    def clean
      call_command(TrySailBlogNotification::Command::CleanCommand)
    end

    no_commands do

      def invoke_command(command, *args)
        app = TrySailBlogNotification::Application.app
        app.log.level = options['log-level'] unless options['log-level'].nil?

        super(command, *args)
      end

      # Call command class.
      #
      # @param [TrySailBlogNotification::Command::BaseCommand]
      def call_command(klass)
        command = klass.new(options, args)
        command.start
      end

    end

  end
end