require 'trysail_blog_notification/last_article'

describe TrySailBlogNotification::LastArticle do

  let(:title) { 'Test title' }
  let(:url) { 'https://hiroto-k.net/' }
  let(:last_update) { '2018-02-08' }
  let(:default_argument) { {
    title: title,
    url: url,
    last_update: last_update,
  }}
  let(:last_article) { TrySailBlogNotification::LastArticle.new(default_argument) }

  describe '#to_h' do

    let(:hash) { last_article.to_h }

    context 'return hash' do
      it { expect(hash).to(be_a(Hash)) }
    end

    context 'eq title' do
      it { expect(hash[:title]).to(eql(title)) }
    end

    context 'eq url' do
      it { expect(hash[:url]).to(eql(url)) }
    end

    context 'eq last_update' do
      it { expect(hash[:last_update]).to(eql(last_update)) }
    end
  end

  describe '#[]' do

    describe 'access with String' do
      context 'access title' do
        it { expect(last_article['title']).to(eql(title)) }
      end

      context 'access url' do
        it { expect(last_article['url']).to(eql(url)) }
      end

      context 'access last_update' do
        it { expect(last_article['last_update']).to(eql(last_update)) }
      end

      context 'access nothing attr' do
        it { expect(last_article['example']).to(be_nil) }
      end
    end

    describe 'access with Symbol' do
      context 'access title' do
        it { expect(last_article[:title]).to(eql(title)) }
      end

      context 'access url' do
        it { expect(last_article[:url]).to(eql(url)) }
      end

      context 'access last_update' do
        it { expect(last_article[:last_update]).to(eql(last_update)) }
      end

      context 'access nothing attr' do
        it { expect(last_article[:example]).to(be_nil) }
      end

    end

  end

end