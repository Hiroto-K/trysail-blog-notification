# frozen_string_literal: true

module TrySailBlogNotification
  class Plugin

    include TrySailBlogNotification::Util

    # Base dir path
    #
    # @return [String]
    attr_reader :base_dir

    # Initialize Plugin
    #
    # @param [String] base_dir Base dir path
    def initialize(base_dir)
      @base_dir = base_dir
    end

    # Get plugin files
    #
    # @return [Array]
    def plugin_files
      dirs = get_dirs
      get_files(dirs)
    end

    # Load plugin files
    #
    # @return [Object]
    def load_plugins
      plugin_files.each do |file|
        require file
      end
    end

    private

    # Get dirs.
    #
    # @return [Array]
    def get_dirs
      dirs = Dir.glob(base_path('/plugin/*'))
      dirs.select! { |d|
        File.directory?(d)
      }
      dirs.sort
    end

    # Get plugin files.
    #
    # @return [Array]
    def get_files(dirs)
      plugin_files = []

      dirs.each do |dir|
        base_name = File.basename(dir)
        plugin_file = File.join(dir, "#{base_name}.rb")

        unless File.exist?(plugin_file)
          logger.warn("Plugin \"#{base_name}\" : file \"#{plugin_file}\" doe's not exist.")
          next
        end

        plugin_files.push(plugin_file)
      end

      plugin_files
    end

    # Get the path to the base.
    #
    # @return [String]
    def base_path(path = '')
      File.join(@base_dir, path)
    end

  end
end