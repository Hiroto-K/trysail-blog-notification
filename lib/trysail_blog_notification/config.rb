# frozen_string_literal: true

module TrySailBlogNotification
  class Config

    # Config
    #
    # @return [Hash]
    attr_reader :raw_config

    # Initialize TrySailBlogNotification::Config
    #
    # @param [Hash] config
    def initialize(config = {})
      @raw_config = config.with_indifferent_access
    end

    # Get config
    #
    # @param [String|Symbol|NilClass] key
    # @param [Object] default
    # @return [Object]
    def get(key = nil, default = nil)
      return raw_config if key.nil?
      return get_by_string(key, default) if key.is_a?(String)
      get_by_symbol(key, default)
    end

    # Checks whether a config exists
    #
    # @param [String|Symbol] key
    # @return [TrueClass|FalseClass]
    def has?(key)
      return raw_config.key?(key) unless key.is_a?(String)

      config = raw_config
      key.split('.').each do |segment|
        return false unless config.is_a?(Hash)
        return false unless config.key?(segment)
        config = config[segment]
      end

      true
    end

    # Access to key
    #
    # @param [String|Symbol|Object] key
    # @return [Object]
    def [](key)
      raw_config[key]
    end

    private

    # Get key by Symbol
    #
    # @param [Symbol] key
    # @param [Object] default
    # @return [Object]
    def get_by_symbol(key, default)
      return default unless raw_config.key?(key)
      raw_config[key]
    end

    # Get key by String
    #
    # @param [String] key
    # @param [Object] default
    # @return [Object]
    def get_by_string(key, default)
      config = raw_config
      key.split('.').each do |segment|
        return default unless config.is_a?(Hash)
        return default unless config.key?(segment)
        config = config[segment]
      end

      config
    end

  end
end