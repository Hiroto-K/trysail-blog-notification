module TrySailBlogNotification
  module Util

    # Return Application instance.
    #
    # @return [TrySailBlogNotification::Application]
    def app
      TrySailBlogNotification::Application.app
    end

    # Return Logger instance.
    #
    # @return [Logger]
    def logger
      app.logger
    end

  end
end