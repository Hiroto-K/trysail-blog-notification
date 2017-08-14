module TrySailBlogNotification
  class Log

    # Log file path.
    #
    # @return [String]
    attr_reader :file

    # ActiveSupport::Logger instance.
    #
    # @return [ActiveSupport::Logger]
    attr_reader :logger

    # ActiveSupport::Logger instance.
    #
    # @return [ActiveSupport::Logger]
    attr_reader :stdout_logger

    # Multiple logger instance.
    #
    # @return [Module]
    attr_reader :multiple_loggers

    # Initialize Log class instance.
    #
    # @param [String] file Log file path.
    # @param [Symbol|String] level Logger level.
    def initialize(file, level)
      @file = file
      create_log_file

      @logger = ActiveSupport::Logger.new(@file)
      @logger.formatter = Logger::Formatter.new
      @stdout_logger = ActiveSupport::Logger.new(STDOUT)
      @multiple_loggers = ActiveSupport::Logger.broadcast(@stdout_logger)
      @logger.extend(@multiple_loggers)
      @logger.level = get_level_value(level)
      @logger.progname = App.name
    end

    # Send missing method.
    #
    # @param [String] name Method name.
    # @param [Array] args Method arguments.
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
    # @param [Symbol|String] value
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