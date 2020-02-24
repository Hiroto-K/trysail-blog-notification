# frozen_string_literal: true

module BlogNotification
  class Cli < Thor

    class_option 'log-level', desc: 'Set the logger level.', type: :string, enum: %w(fatal error warn info debug)

    package_name BlogNotification::Application::NAME

    no_commands do
      def invoke_command(command, *args)
        app = BlogNotification::Application.app
        app.log.level = options['log-level'] unless options['log-level'].nil?

        super(command, *args)
      end

      # Call command class.
      #
      # @param klass [Class] Sub class of BlogNotification::Command::BaseCommand.
      def call_command(klass)
        command = klass.new(options, args)
        command.setup
        command.start
      end
    end

    desc 'start', 'Run trysail-blog-notification.'
    option 'no-notification', desc: 'No send the notification.', type: :boolean, default: false
    def start
      call_command(BlogNotification::Command::StartCommand)
    end

    desc 'console', 'Start trysail-blog-notification console'
    def console
      call_command(BlogNotification::Command::ConsoleCommand)
    end

    desc 'clean', 'Clean log and data files.'
    option 'verbose', desc: 'Show verbose', type: :boolean, default: true
    option 'force', desc: 'Force remove', type: :boolean, default: false
    option 'noop', desc: 'Dry run', type: :boolean, default: false
    def clean
      call_command(BlogNotification::Command::CleanCommand)
    end

    desc 'client:test', 'Test client class.'
    option 'client-name', desc: 'Client name', required: true, type: :string
    option 'test-name', desc: 'Test data name', type: :string
    option 'title', desc: 'Test data of title', type: :string
    option 'url', desc: 'Test data of url', type: :string
    option 'last-update', desc: 'Test data of last updated', type: :string
    def client_test
      call_command(BlogNotification::Command::ClientTestCommand)
    end
    map 'client:test' => 'client_test'

  end
end