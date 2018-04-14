# frozen_string_literal: true

require 'fileutils'

module TrySailBlogNotification
  class Application

    # Application name.
    NAME = 'trysail-blog-notification'

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
    # @return [Array]
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
    # @param [String] base_dir
    # @param [Hash] config
    def initialize(base_dir, config)
      @@app = self
      @base_dir = base_dir
      @config = TrySailBlogNotification::Config.new(config)

      @dump_file = base_path(@config.get('data.dump.file'))
      log_file = base_path(@config.get('data.log.file'))
      log_level = @config.get('data.log.level')
      @log = TrySailBlogNotification::Log.new(log_file, log_level)

      logger.info('Started application.')

      @clients = []

      @plugin = TrySailBlogNotification::Plugin.new(@base_dir)
    end

    # Get application instance
    #
    # @return [TrySailBlogNotification::Application]
    def self.app
      @@app
    end

    # Add client.
    #
    # @param [TrySailBlogNotification::Client::BaseClient] client
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
    def run
      @urls = @config.get(:urls)

      add_clients

      TrySailBlogNotification::Cli.start(ARGV)
    rescue RuntimeError => e
      logger.error(e)
    end

    # Get the path to the base.
    #
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

    # Set file config. Expand file path.
    #
    # @param [Hash] config
    # @return [Hash]
    def set_file_config(config)
      config[:data][:log][:file] = base_path(config[:data][:log][:file])
      config[:data][:dump][:file] = base_path(config[:data][:dump][:file])

      config
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