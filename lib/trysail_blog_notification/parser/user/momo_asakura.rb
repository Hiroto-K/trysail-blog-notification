module TrySailBlogNotification::Parser::User
  class MomoAsakura < TrySailBlogNotification::Parser::BaseParser

    # Start parse.
    #
    # @param [Nokogiri::HTML::Document] nokogiri
    # @return [TrySailBlogNotification::LastArticle]
    def parse(nokogiri)
      @nokogiri = nokogiri

      first_article = get_top_page_articles.first
      title_obj = get_title_obj(first_article)
      title = get_title(title_obj)
      url = title_obj.attributes['href'].value
      last_update = get_last_update(first_article)

      TrySailBlogNotification::LastArticle.new(title, url, last_update)
    end

    private

    # Get top page articles.
    #
    # @return [Nokogiri::XML::NodeSet]
    def get_top_page_articles
      @nokogiri.xpath('//div[@class="skinMainArea2"]/article[@class="js-entryWrapper"]')
    end

    # Get title object.
    #
    # @param [Nokogiri::XML::Element] article
    # @return [Nokogiri::XML::Element]
    def get_title_obj(article)
      article.xpath('//h1/a[@class="skinArticleTitle"]').first
    end

    # Get title.
    #
    # @param [Nokogiri::XML::Element]
    # @return [String]
    def get_title(title_obj)
      title_obj.children.first.content.strip
    end

    # Get last update date.
    #
    # @param [Nokogiri::XML::Element]
    # @return [String]
    def get_last_update(article)
      article.xpath('//span[@class="articleTime"]//time').first.content
    end

  end
end