# frozen_string_literal: true

require File.join(File.dirname(__FILE__), '/base_parser.rb')

module TrySailBlogNotification::Parser
  class TrySailParser < BaseParser

    # Start parse.
    #
    # @param nokogiri [Nokogiri::HTML::Document]
    # @return [TrySailBlogNotification::LastArticle]
    def parse(nokogiri)
      @nokogiri = nokogiri

      last_article = get_last_article
      title_object = get_title_obj(last_article)
      title = get_title(title_object)
      url = get_url(title_object)
      last_update = get_last_update(last_article)

      create_last_article(title: title, url: url, last_update: last_update)
    end

    private

    # Get top page articles.
    #
    # @return [Nokogiri::XML::Element]
    def get_last_article
      @nokogiri.xpath('//div[@class="skinMainArea2"]/article[@class="js-entryWrapper"]').first
    end

    # Get title object.
    #
    # @param article [Nokogiri::XML::Element]
    # @return [Nokogiri::XML::Element]
    def get_title_obj(article)
      article.xpath('.//h1/a[@class="skinArticleTitle"]').first
    end

    # Get last article title.
    #
    # @param title_object [Nokogiri::XML::Element]
    # @return [String]
    def get_title(title_object)
      title_object.children.first.content.strip
    end

    # Get last article url.
    #
    # @param title_object [Nokogiri::XML::Element]
    # @return [String]
    def get_url(title_object)
      path = title_object.attributes['href'].value

      build_url(path: path)
    end

    # Get last update date.
    #
    # @param article [Nokogiri::XML::Element]
    # @return [String]
    def get_last_update(article)
      article.xpath('.//span[@class="articleTime"]//time').first.content
    end
  end
end