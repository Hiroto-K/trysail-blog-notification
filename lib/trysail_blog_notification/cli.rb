module TrySailBlogNotification
  class Cli < Thor

    class_option 'log-level', desc: 'Set the logger level (fatal, error, warn, info, debug).', type: :string

    package_name 'trysail-blog-notification'

    desc 'start', 'Run trysail-blog-notification.'
    def start
      command = TrySailBlogNotification::Command::StartCommand.new(options, args)
      command.start
    end

  end
end