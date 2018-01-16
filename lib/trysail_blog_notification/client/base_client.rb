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

    # Update.
    #
    # @param [String] name
    # @param [TrySailBlogNotification::LastArticle] status
    def update(name, status)
      @sys_date   = Time.now
      @sys_date_s = @sys_date.to_s

      @title = status['title']
      @url = status['url']
      @last_update = status['last_update']
    end

  end
end