module TrySailBlogNotification
  class Cli < Thor

    package_name 'trysail-blog-notification'

    desc 'start', 'Run trysail-blog-notification.'
    def start
      command = TrySailBlogNotification::Command::StartCommand.new(options, args)
      command.start
    end

  end
end