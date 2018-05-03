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
    # @param config [Hash] Config hash.
    def initialize(config)
      @config = config
    end

    # Setup client class.
    # This method call in after "initialize" method call.
    def setup
    end

    # This method call in before "update" method call.
    #
    # @param name [String] Blog name.
    # @param status [TrySailBlogNotification::LastArticle] Blog state.
    def before_update(name, status)
    end

    # Update.
    #
    # @param name [String] Blog name.
    # @param status [TrySailBlogNotification::LastArticle] Blog state.
    def update(name, status)
      raise NotImplementedError, "You must implement #{self.class}##{__method__}"
    end

  end
end