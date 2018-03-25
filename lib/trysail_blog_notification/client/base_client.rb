# frozen_string_literal: true

module TrySailBlogNotification::Client
  class BaseClient

    include TrySailBlogNotification::Util

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
    end

  end
end