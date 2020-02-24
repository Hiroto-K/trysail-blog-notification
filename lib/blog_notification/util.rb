module BlogNotification
  module Util

    # Return Application instance.
    #
    # @return [BlogNotification::Application]
    def app
      BlogNotification::Application.app
    end

    # Return Logger instance.
    #
    # @return [Logger]
    def logger
      app.logger
    end

  end
end