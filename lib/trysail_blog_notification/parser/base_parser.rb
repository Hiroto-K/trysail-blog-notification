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
    # @param nokogiri [Nokogiri::HTML::Document]
    # @return [TrySailBlogNotification::LastArticle]
    def parse(nokogiri)
      raise NotImplementedError, "You must implement #{self.class}##{__method__}"
    end

    private

    # Build url from path
    #
    # @param host [String]
    # @param path [String]
    # @return [String]
    def build_url(host: @blog_host, path:)
      URI.join(host, path).to_s
    end

    # Build last article.
    #
    # @param params [Hash]
    # @return [TrySailBlogNotification::LastArticle]
    def create_last_article(*params)
      TrySailBlogNotification::LastArticle.new(params)
    end

  end
end