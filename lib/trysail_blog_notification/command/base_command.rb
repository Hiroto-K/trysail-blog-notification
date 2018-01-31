module TrySailBlogNotification::Command
  class BaseCommand

    # Start command.
    def start
    end

    private

    # Return application instance.
    #
    # @return [TrySailBlogNotification::Application]
    def app
      TrySailBlogNotification::Application.app
    end

  end
end