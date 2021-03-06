require 'blog_notification/last_article'
require 'blog_notification/rss_reader'

describe BlogNotification::RssReader do

  let(:rss_content) { File.read(File.join(__dir__, '/../../fixtures/files/rss.rss')) }
  let(:reader) { BlogNotification::RssReader.new(rss_content) }

  describe '#initialize' do
    it 'Instance of BlogNotification::RssReader' do
      expect(reader).to be_a BlogNotification::RssReader
    end

    it 'Has RSS::Rss' do
      expect(reader.rss).to be_a RSS::Rss
    end
  end

  describe '#last_article' do

    it 'return BlogNotification::LastArticle' do
      last_article = reader.last_article
      expect(last_article).to be_a BlogNotification::LastArticle
    end

    it 'eql title' do
      last_article = reader.last_article
      expect(last_article.title).to eq 'Test title 1'
    end

    it 'eql url' do
      last_article = reader.last_article
      expect(last_article.url).to eq 'https://tsbn.test/test-title-1'
    end

    it 'eql last_update' do
      last_article = reader.last_article
      expect(last_article.last_update).to eq 'Sun, 01 Apr 2018 21:57:17 +0900'
    end
  end

end
