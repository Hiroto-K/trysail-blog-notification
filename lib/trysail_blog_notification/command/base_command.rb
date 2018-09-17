# frozen_string_literal: true

module TrySailBlogNotification
  module Command
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
      # @param options [Hash] Command options.
      # @param args [Array] Command arguments.
      def initialize(options, args)
        @options = options.with_indifferent_access
        @args = args
      end

      # Set up command class.
      def setup
      end

      # Start command.
      def start
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end
    end
  end
end