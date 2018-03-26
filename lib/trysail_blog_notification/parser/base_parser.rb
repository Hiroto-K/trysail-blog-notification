# frozen_string_literal: true

module TrySailBlogNotification::Parser
  class BaseParser

    include TrySailBlogNotification::Util

    # Initialize parser.
    def initialize
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