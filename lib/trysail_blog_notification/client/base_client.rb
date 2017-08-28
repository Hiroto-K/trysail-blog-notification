module TrySailBlogNotification::Client
  class BaseClient

    # Application instance.
    #
    # @return [TrySailBlogNotification::Application]
    attr_reader :app

    # Config hash.
    #
    # @return [Hash]
    attr_reader :config

    # Initialize client.
    #
    # @param [TrySailBlogNotification::Application] app Application instance.
    # @param [Hash] config Config hash.
    def initialize(app, config)
      @app = app
      @config = config
    end

  end
end