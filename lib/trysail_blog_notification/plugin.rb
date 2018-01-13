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
    end

    # Load plugin files
    #
    # @return [Object]
    def load_plugins
    end

  end
end