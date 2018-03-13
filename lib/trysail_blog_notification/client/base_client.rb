# frozen_string_literal: true

module TrySailBlogNotification::Client
  class BaseClient

    # Config hash.
    #
    # @return [Hash]
    attr_reader :config

    # Initialize client.
    #
    # @param [Hash] config Config hash.
    def initialize(config)
      @config = config
    end

    # Update.
    #
    # @param [String] name
    # @param [TrySailBlogNotification::LastArticle] status
    def update(name, status)
      @sys_date   = Time.now
      @title = status['title']
      @url = status['url']
      @last_update = status['last_update']
    end

    private

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
      app.log.logger
    end

  end
end