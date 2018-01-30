module TrySailBlogNotification
  class Cli < Thor

    desc "start", "Run trysail-blog-notification."
    def start
      command = TrySailBlogNotification::Command::StartCommand.new
      command.start
    end

  end
end