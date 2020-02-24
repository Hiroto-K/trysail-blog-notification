# frozen_string_literal: true

module BlogNotification::Client
  class BaseClient

    include BlogNotification::Util

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
    # @param article [BlogNotification::LastArticle] Blog state.
    def before_update(name, article)
    end

    # Update.
    #
    # @param name [String] Blog name.
    # @param article [BlogNotification::LastArticle] Blog state.
    def update(name, article)
      raise NotImplementedError, "You must implement #{self.class}##{__method__}"
    end

  end
end