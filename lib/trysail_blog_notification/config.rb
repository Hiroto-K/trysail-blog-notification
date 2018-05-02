# frozen_string_literal: true

module TrySailBlogNotification
  class Config

    # Key delimiter.
    DELIMITER = '.'

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
      return default unless raw_config.key?(key)
      raw_config[key]
    end

    # Checks whether a config exists
    #
    # @param [String|Symbol] key
    # @return [TrueClass|FalseClass]
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
    # @param [String|Symbol|Object] key
    # @return [Object]
    def [](key)
      raw_config[key]
    end

    private

    # Split key
    #
    # @return [String]
    # @return [Array]
    def split_key(key)
      key.split(DELIMITER)
    end

    # Get key by String
    #
    # @param [String] key
    # @param [Object] default
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