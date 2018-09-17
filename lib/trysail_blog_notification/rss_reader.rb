require 'rss'

module TrySailBlogNotification
  class RssReader

    # Rss.
    #
    # @return [RSS::Rss]
    attr_reader :rss

    # Initialize TrySailBlogNotification::RssReader.
    #
    # @param rss_content [String]
    def initialize(rss_content)
      @rss = RSS::Parser::parse(rss_content)
    end

    # Get last article.
    #
    # @return [TrySailBlogNotification::LastArticle]
    def last_article
      item = @rss.items.first

      info = {
        title: item.title,
        url: item.link,
        last_update: item.pubDate,
      }

      TrySailBlogNotification::LastArticle.new(info)
    end
  end
end
