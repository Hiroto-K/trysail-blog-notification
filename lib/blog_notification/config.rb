# frozen_string_literal: true

module BlogNotification
  class Config

    # Key delimiter.
    DELIMITER = '.'

    # Raw config.
    #
    # @return [Hash]
    attr_reader :raw_config

    # Initialize BlogNotification::Config.
    #
    # @param config [Hash]
    def initialize(config = {})
      @raw_config = config.with_indifferent_access
    end

    # Get config
    #
    # @param key [String, Symbol, NilClass]
    # @param default [Object]
    # @return [Object]
    def get(key = nil, default = nil)
      return raw_config if key.nil?
      return get_by_string(key, default) if key.is_a?(String)
      return default unless raw_config.key?(key)
      raw_config[key]
    end

    # Checks whether a config exists
    #
    # @param key [String, Symbol]
    # @return [true, false]
    def has?(key)
      return raw_config.key?(key) unless key.is_a?(String)

      config = raw_config
      split_key(key).each do |segment|
        return false unless config.is_a?(Hash) && config.key?(segment)
        config = config[segment]
      end

      true
    end

    # Access to key
    #
    # @param key [String, Symbol, Object]
    # @return [Object]
    def [](key)
      raw_config[key]
    end

    private

    # Split key.
    #
    # @param key [String]
    # @return [Array<String>]
    def split_key(key)
      key.split(DELIMITER)
    end

    # Get key by String.
    #
    # @param key [String]
    # @param default [Object]
    # @return [Object]
    def get_by_string(key, default)
      config = raw_config
      split_key(key).each do |segment|
        return default unless config.is_a?(Hash) && config.key?(segment)
        config = config[segment]
      end

      config
    end

  end
end