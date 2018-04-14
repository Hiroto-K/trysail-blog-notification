# frozen_string_literal: true

module TrySailBlogNotification
  class Config

    attr_reader :raw_config

    # Initialize TrySailBlogNotification::Config
    #
    # @param [Hash] config
    def initialize(config = {})
      @raw_config = config
    end

    # Get config
    #
    # @param [Symbol|String|NilClass] key
    # @param [Object] default
    # @return [Object]
    def get(key = nil, default = nil)
      return raw_config if key.nil?
      return get_by_symbol(key, default) if key.is_a?(Symbol)
    end

    private

    # Get key by symbol
    #
    # @param [Symbol] key
    # @param [Object] default
    # @return [Object]
    def get_by_symbol(key, default)
      return default unless raw_config.key?(key)
      raw_config[key]
    end

  end
end