module TrySailBlogNotification::Parser::User
  class ShiinaNatsukawa < TrySailBlogNotification::Parser::BaseParser

    # Start parse.
    #
    # @param [Nokogiri::HTML::Document] nokogiri
    # @return [TrySailBlogNotification::LastArticle]
    def parse(nokogiri)
      articles = nokogiri.xpath('//div[@class="skinMainArea2"]/article[@class="js-entryWrapper"]')
      first_article = articles.first

      title_obj = first_article.xpath('//h1/a[@class="skinArticleTitle"]').first
      title = title_obj.children.first.content.strip
      url = title_obj.attributes['href'].value
      last_update = first_article.xpath('//span[@class="articleTime"]//time').first.content

      TrySailBlogNotification::LastArticle.new(title, url, last_update)
    end

  end
end