# frozen_string_literal: true

module TrySailBlogNotification
  class StateUpdater

    include TrySailBlogNotification::Util

    attr_reader :states

    # Initialize StateUpdater
    #
    # @param [Hash] urls
    def initialize(urls)
      @urls = urls
      @states = {}
    end

    # Run update
    def update
      @urls.each do |name, info|
        logger.debug("Run \"#{name}\"")

        if info['rss']
          last_article = get_by_rss(info['rss'])
        else
          last_article = get_by_parser(info['url'], info['parser'])
        end

        logger.debug(last_article)

        @states[name] =last_article
      end
    end

    private

    # Create http instance.
    #
    # @param [String] url
    # @return [TrySailBlogNotification::HTTP]
    def create_http(url)
      TrySailBlogNotification::HTTP.new(url)
    end

    # Create http instance.
    #
    # @param [String] url
    # @return [TrySailBlogNotification::HTTP]
    def http_request(url)
      http = create_http(url)
      http.request

      http
    end

    # Get last article by rss
    #
    # @param [String] rss_url
    # @return [TrySailBlogNotification::LastArticle]
    def get_by_rss(rss_url)
      http = http_request(rss_url)
      rss_content = http.body
      rss_reader = TrySailBlogNotification::RssReader.new(rss_content)

      rss_reader.last_article
    end

    # Get last article by parser
    #
    # @param [String] url
    # @param [String] parser_class
    # @return [TrySailBlogNotification::LastArticle]
    def get_by_parser(url, parser_class)
      logger.debug('Get response.')

      http = http_request(url)
      html = http.body
      nokogiri = Nokogiri::HTML.parse(html)

      logger.debug('Get last articles.')
      klass = parser_class.constantize
      parser = klass.new
      last_article = parser.parse(nokogiri)
      raise "#{parser_class}#.parse method is not returned TrySailBlogNotification::LastArticle instance." unless last_article.is_a?(TrySailBlogNotification::LastArticle)

      last_article
    end

  end
end