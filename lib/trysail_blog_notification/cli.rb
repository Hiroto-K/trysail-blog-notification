module TrySailBlogNotification
  class Cli < Thor

    class_option 'log-level', desc: 'Set the logger level (fatal, error, warn, info, debug).', type: :string

    package_name 'trysail-blog-notification'

    desc 'start', 'Run trysail-blog-notification.'
    option 'no-notification', desc: 'No send the notification.', type: :boolean, default: false
    def start
      command = TrySailBlogNotification::Command::StartCommand.new(options, args)
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