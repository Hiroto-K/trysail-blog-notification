require 'spec_helper'
require 'trysail_blog_notification/last_article'

describe TrySailBlogNotification::LastArticle do

  title = 'Test title'
  url = 'https://hiroto-k.net/'
  last_update = '2018-02-08'
  default_argument = {
    title: title,
    url: url,
    last_update: last_update,
  }

  describe '#to_h' do
    last_article = TrySailBlogNotification::LastArticle.new(default_argument)

    example 'return hash' do
      expect(last_article.to_h).to(be_a(Hash))
    end

    example 'eql title' do
      expect(last_article.to_h[:title]).to(eql(title))
    end

    example 'eql url' do
      expect(last_article.to_h[:url]).to(eql(url))
    end

    example 'eql last_update' do
      expect(last_article.to_h[:last_update]).to(eql(last_update))
    end
  end

  describe '#[]' do
    last_article = TrySailBlogNotification::LastArticle.new(default_argument)

    example 'access title with string' do
      expect(last_article['title']).to(eql(title))
    end

    example 'access url with string' do
      expect(last_article['url']).to(eql(url))
    end

    example 'access last_update with string' do
      expect(last_article['last_update']).to(eql(last_update))
    end

    example 'access title with symbol' do
      expect(last_article[:title]).to(eql(title))
    end

    example 'access url with symbol' do
      expect(last_article[:url]).to(eql(url))
    end

    example 'access last_update with symbol' do
      expect(last_article[:last_update]).to(eql(last_update))
    end

    example 'access nothing attr with string' do
      expect(last_article['example']).to(be_nil)
    end

    example 'access nothing attr with symbol' do
      expect(last_article[:example]).to(be_nil)
    end

  end

end