module TrySailBlogNotification
  class Plugin

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
    def get_plugin_files
      plugin_files = []
      dirs = Dir.glob(File.join(@base_dir, '/plugin/*')).select {|d| File.directory?(d) }.sort
      dirs.each do |dir|
        base_name = File.basename(dir)
        plugin_file = File.join(dir, "#{base_name}.rb")
        plugin_files.push(plugin_file)
      end
      plugin_files
    end

    # Load plugin files
    #
    # @return [Object]
    def load_plugins
      get_plugin_files.each do |file|
        require file
      end
    end

  end
end