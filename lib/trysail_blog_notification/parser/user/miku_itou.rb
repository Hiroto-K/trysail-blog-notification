module TrySailBlogNotification::Parser::User
  class MikuItou < TrySailBlogNotification::Parser::BaseParser

    # Start parse.
    #
    # @param [Nokogiri::HTML::Document] nokogiri
    # @return [TrySailBlogNotification::LastArticle]
    def parse(nokogiri)
      @nokogiri = nokogiri

      first_article = get_article
      title_obj = get_title_obj(first_article)
      title = get_title(title_obj)
      url = title_obj.attributes['href'].value
      last_update = get_last_update(first_article)

      TrySailBlogNotification::LastArticle.new(title, url, last_update)
    end

    private

    # Get top page articles.
    #
    # @return [Nokogiri::XML::Element]
    def get_article
      @nokogiri.xpath('//div[@class="entry new js-entryWrapper"]').first
    end

    # Get title object.
    #
    # @param [Nokogiri::XML::Element] article
    # @return [Nokogiri::XML::Element]
    def get_title_obj(article)
      article.xpath('//h3[@class="title"]/a').first
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
      article.xpath('//div[@class="entry_head"]//span[@class="date"]').first.content.strip
    end

  end
end