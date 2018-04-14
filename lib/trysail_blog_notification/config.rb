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
    end

  end
end