require 'spec_helper'
require 'trysail_blog_notification/last_article'
require 'trysail_blog_notification/rss_reader'

describe TrySailBlogNotification::RssReader do

  let(:rss_content) { File.read(File.expand_path(File.join(__dir__, '/../../fixtures/files/rss.rss'))) }
  let(:reader) { TrySailBlogNotification::RssReader.new(rss_content) }

  describe '#initialize' do
    context 'Instance of TrySailBlogNotification::RssReader' do
      it { expect(reader).to(be_a(TrySailBlogNotification::RssReader)) }
    end

    context 'Has of RSS::Rss' do
      it { expect(reader.rss).to(be_a(RSS::Rss)) }
    end
  end

  describe '#last_article' do
    let(:last_article) { reader.last_article }

    context 'Instance of TrySailBlogNotification::LastArticle' do
      it { expect(last_article).to(be_a(TrySailBlogNotification::LastArticle)) }
    end

    context 'eql title' do
      it { expect(last_article.title).to(eql('Test title 1')) }
    end

    context 'eql url' do
      it { expect(last_article.url).to(eql('https://tsbn.test/test-title-1')) }
    end

    context 'eql last_update' do
      it { expect(last_article.last_update).to(eql('Sun, 01 Apr 2018 21:57:17 +0900')) }
    end
  end

end
