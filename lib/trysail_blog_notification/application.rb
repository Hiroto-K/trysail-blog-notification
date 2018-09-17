# frozen_string_literal: true

require 'fileutils'

module TrySailBlogNotification
  class Application

    # Application name.
    NAME = 'trysail-blog-notification'.freeze

    # Base dir
    #
    # @return [String]
    attr_reader :base_dir

    # Config
    #
    # @return [TrySailBlogNotification::Config]
    attr_reader :config

    # Dump file path.
    #
    # @return [String]
    attr_reader :dump_file

    # Logger
    #
    # @return [TrySailBlogNotification::Log]
    attr_reader :log

    # Client instances.
    #
    # @return [Array<TrySailBlogNotification::Client::BaseClient>]
    attr_reader :clients

    # Target urls
    #
    # @return [Hash]
    attr_reader :urls

    # Plugin
    #
    # @return [TrySailBlogNotification::Plugin]
    attr_reader :plugin

    # Initialize application.
    #
    # @param base_dir [String]
    # @param config [Hash]
    def initialize(base_dir, config)
      @@app = self
      @base_dir = base_dir
      @clients = []

      setup_config(config)
      setup_logger

      logger.info('Started application.')

      setup_dump_file
      setup_plugin
    end

    # Get application instance
    #
    # @return [TrySailBlogNotification::Application]
    def self.app
      @@app
    end

    # Add client.
    #
    # @param client [TrySailBlogNotification::Client::BaseClient]
    def add_client(client)
      raise "Client is not instance of 'TrySailBlogNotification::Client::BaseClient'." unless client.is_a?(TrySailBlogNotification::Client::BaseClient)

      logger.debug("Call #{client.class}#setup method")
      client.setup

      logger.debug("Register \"#{client.class}\" client.")
      @clients.push(client)
    end

    # Load plugins
    def load_plugins
      logger.debug('Load plugins')
      @plugin.plugin_files.each do |file|
        begin
          logger.debug("Load plugin file : #{file}")
          require file
        rescue RuntimeError => e
          logger.error("Error in load plugin : #{file}")
          logger.error(e)
        end
      end
    end

    # Run application.
    def run(args = ARGV)
      @urls = @config.get(:urls)

      add_clients

      TrySailBlogNotification::Cli.start(args)
    rescue RuntimeError => e
      logger.error(e)
    end

    # Get the path to the base.
    #
    # @param path [String]
    # @return [String]
    def base_path(path = '')
      File.join(@base_dir, path)
    end

    # Return Logger instance.
    #
    # @return [Logger]
    def logger
      @log.logger
    end

    private

    # Setup config
    def setup_config(config)
      @config = TrySailBlogNotification::Config.new(config)
    end

    # Setup logger
    def setup_logger
      log_file = base_path(@config.get('data.log.file'))
      log_level = @config.get('data.log.level')
      @log = TrySailBlogNotification::Log.new(log_file, log_level)
    end

    # Setup dump file
    def setup_dump_file
      @dump_file = base_path(@config.get('data.dump.file'))
    end

    # Setup plugin
    def setup_plugin
      @plugin = TrySailBlogNotification::Plugin.new(@base_dir)
    end

    # Add clients.
    def add_clients
      @config.get(:clients).each do |name, options|
        client_class = options[:client]
        config = options[:config]

        logger.debug("Register #{name}(\"#{client_class}\") client.")

        klass = client_class.constantize
        add_client(klass.new(config))
      end
    end
  end
end
