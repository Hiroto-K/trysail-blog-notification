# frozen_string_literal: true

module BlogNotification
  class StateUpdater

    include BlogNotification::Util

    # States hash.
    #
    # @return [Hash]
    attr_reader :states

    # Initialize StateUpdater
    #
    # @param urls [Hash]
    def initialize(urls)
      @urls = urls
      @states = {}
    end

    # Run update
    def update
      @urls.each do |name, info|
        logger.debug("Run \"#{name}\"")

        last_article = pull_last_article_by_rss(info['rss'])

        logger.debug(last_article)

        @states[name] =last_article
      end
    end

    private

    # Create http instance.
    #
    # @param url [String]
    # @return [BlogNotification::HTTP]
    def create_http(url)
      BlogNotification::HTTP.new(url)
    end

    # Create http instance.
    #
    # @param url [String]
    # @return [BlogNotification::HTTP]
    def http_request(url)
      logger.debug("Send http request : #{url}.")

      http = create_http(url)
      http.request

      http
    end

    # Get last article by rss
    #
    # @param rss_url [String]
    # @return [BlogNotification::LastArticle]
    def pull_last_article_by_rss(rss_url)
      http = http_request(rss_url)
      rss_content = http.body
      rss_reader = BlogNotification::RssReader.new(rss_content)

      rss_reader.last_article
    end
  end
end