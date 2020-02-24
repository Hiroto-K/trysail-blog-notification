# frozen_string_literal: true

module BlogNotification
  class Log

    # ActiveSupport::Logger instance.
    #
    # @return [ActiveSupport::Logger]
    attr_reader :logger

    # Initialize Log class instance.
    #
    # @param level [Symbol, String] Logger level.
    def initialize(level)
      @logger = ActiveSupport::Logger.new(STDOUT)
      @logger.formatter = Logger::Formatter.new
      @logger.level = get_level_value(level)
      @logger.progname = BlogNotification::Application::NAME
    end

    # Push new logger
    #
    # @param output [String] Log file path.
    def push_logger(output)
      new_logger = ActiveSupport::Logger.new(output)
      new_logger.formatter = Logger::Formatter.new

      multiple_loggers = ActiveSupport::Logger.broadcast(new_logger)
      @logger.extend(multiple_loggers)
    end

    # Set logger level
    #
    # @param level [Symbol, String]
    # @return [Object]
    def level=(level)
      level_value = get_level_value(level)
      @logger.level = level_value
      level_value
    end

    # Send missing method.
    #
    # @param name [Symbol] Method name.
    # @param args [Array] Method arguments.
    # @return [Object]
    def method_missing(name, *args)
      @logger.send(name, *args)
    end

    private

    # Create log file if the log file does not exist.
    #
    # @return [Object]
    def create_log_file
      FileUtils.touch(@file) unless File.exist?(@file)
    end

    # Get logger level value.
    #
    # @param value [Symbol, String]
    # @return [Object]
    def get_level_value(value)
      map = {
        fatal: Logger::FATAL,
        error: Logger::ERROR,
        warn: Logger::WARN,
        info: Logger::INFO,
        debug: Logger::DEBUG,
      }
      value = value.to_sym
      raise RuntimeError, "Logger level '#{value}' does not exist." unless map.has_key?(value)
      map[value]
    end

  end
end