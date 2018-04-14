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

  end
end