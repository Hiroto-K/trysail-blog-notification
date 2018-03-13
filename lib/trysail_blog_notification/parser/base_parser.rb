# frozen_string_literal: true

module TrySailBlogNotification::Parser
  class BaseParser

    include TrySailBlogNotification::Util

    # Config hash.
    #
    # @return [Hash]
    attr_reader :config

    # Initialize parser.
    #
    # @param [Hash] config Config hash.
    def initialize(config)
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
    # @param [String] host
    # @param [String] path
    # @return [String]
    def build_url(host: @blog_host, path:)
      URI.join(host, path).to_s
    end

  end
end