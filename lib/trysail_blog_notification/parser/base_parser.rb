module TrySailBlogNotification::Parser
  class BaseParser

    # Application instance.
    #
    # @return [TrySailBlogNotification::Application]
    attr_reader :app

    # Config hash.
    #
    # @return [Hash]
    attr_reader :config

    # Initialize parser.
    #
    # @param [TrySailBlogNotification::Application] app Application instance.
    # @param [Hash] config Config hash.
    def initialize(app, config)
      @app = app
      @config = config
      @blog_host = 'https://ameblo.jp/'
    end

    # Start parse.
    #
    # @param [Nokogiri::HTML::Document] nokogiri
    # @return [TrySailBlogNotification::LastArticle]
    def parse(nokogiri)
    end

    private

    # Build url from path
    #
    # @param [String] path
    # @return [String]
    def build_url(path)
      URI.join(@blog_host, path).to_s
    end

  end
end