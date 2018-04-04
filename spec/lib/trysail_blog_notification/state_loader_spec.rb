require 'trysail_blog_notification/last_article'
require 'trysail_blog_notification/state_loader'

describe TrySailBlogNotification::StateLoader do

  let(:state_file) { File.join(__dir__, '/../../fixtures/files/dump.json') }
  let(:state_content) { File.read(state_file) }
  let(:state_loader) { TrySailBlogNotification::StateLoader.new(state_file) }

  describe '#initialize' do
    it 'Instance of TrySailBlogNotification::StateLoader' do
      expect(state_loader).to(be_a(TrySailBlogNotification::StateLoader))
    end
  end

  describe '#to_json' do
    it 'return String' do
      expect(state_loader.to_json).to(be_a(String))
    end

    it 'eql json' do
      expect(state_loader.to_json).to(eql(state_content))
    end
  end

  describe '#to_h' do

    let(:hash) { state_loader.to_h }

    it 'return Hash' do
      expect(hash).to(be_a(Hash))
    end

    it 'have keys' do
      expect(hash).to(have_key('Name1'))
      expect(hash).to(have_key('Name2'))
      expect(hash).to(have_key('Name3'))
    end
  end

  describe '#states' do

    let(:states) { state_loader.states }

    it 'return Hash' do
      expect(states).to(be_a(Hash))
    end

    it 'have keys' do
      expect(states).to(have_key('Name1'))
      expect(states).to(have_key('Name2'))
      expect(states).to(have_key('Name3'))
    end

    it 'have TrySailBlogNotification::LastArticle' do
      expect(states['Name1']).to(be_a(TrySailBlogNotification::LastArticle))
      expect(states['Name2']).to(be_a(TrySailBlogNotification::LastArticle))
      expect(states['Name3']).to(be_a(TrySailBlogNotification::LastArticle))
    end

    it 'eql title' do
      expect(states['Name1'].title).to(eql('hoge'))
    end

    it 'eql url' do
      expect(states['Name1'].url).to(eql('https://tsbn.test/hoge'))
    end

    it 'eql last_update' do
      expect(states['Name1'].last_update).to(eql('Sun, 01 Apr 2018 22:07:28 +0900'))
    end
  end

end