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
    # @return [Hash]
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
      @config = set_file_config(config.with_indifferent_access)

      @dump_file = @config[:data][:dump][:file]
      log_file = @config[:data][:log][:file]
      log_level = @config[:data][:log][:level]
      @log = TrySailBlogNotification::Log.new(log_file, log_level)

      @log.logger.info('Started application.')

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
      @clients.push(client)
    end

    # Load plugins
    def load_plugins
      @log.logger.debug('Load plugins')
      @plugin.get_plugin_files.each do |file|
        begin
          @log.logger.debug("Load plugin file : #{file}")
          require file
        rescue RuntimeError => e
          @log.logger.error("Error in load plugin : #{file}")
          @log.logger.error(e)
        end
      end
    end

    # Run application.
    def run
      @config = set_urls_config(@config)
      @config = set_clients_config(@config)
      @urls = @config[:urls]

      add_clients

      TrySailBlogNotification::Cli.start(ARGV)
    rescue RuntimeError => e
      @log.logger.error(e)
    end

    # Get the path to the base.
    #
    # @return [String]
    def base_path(path = '')
      File.join(@base_dir, path)
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

    # Set urls config.
    #
    # @param [Hash] config
    # @return [Hash]
    def set_urls_config(config)
      config[:urls].keys.each do |name|
        parser = config[:urls][name][:parser]
        config[:urls][name][:parser] = parser.constantize
      end

      config
    end

    # Set clients config.
    #
    # @param [Hash] config
    # @return [Hash]
    def set_clients_config(config)
      config[:clients].keys.each do |name|
        client_class = config[:clients][name][:client]
        config[:clients][name][:client] = client_class.constantize
      end

      config
    end

    # Add clients.
    def add_clients
      @config[:clients].each do |name, options|

        client_class = options[:client]
        config = options[:config]

        @log.logger.debug("Register #{name}(\"#{client_class}\") client.")

        add_client(client_class.new(config))
      end
    end

  end
end