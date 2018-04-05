# frozen_string_literal: true

module TrySailBlogNotification::Command
  class BaseCommand

    include TrySailBlogNotification::Util

    # Command options.
    #
    # @return [Hash]
    attr_reader :options

    # Command args.
    #
    # @return [Array]
    attr_reader :args

    # Initialize Command.
    #
    # @param [Hash] options
    # @param [Array] args
    def initialize(options, args)
      @options = options.with_indifferent_access
      @args = args
    end

    # Start command.
    def start
      raise NotImplementedError, "You must implement #{self.class}##{__method__}"
    end

  end
end