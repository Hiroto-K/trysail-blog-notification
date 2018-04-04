require 'trysail_blog_notification/last_article'
require 'trysail_blog_notification/state_loader'

describe TrySailBlogNotification::StateLoader do

  let(:state_file) { File.join(__dir__, '/../../fixtures/files/dump.json') }
  let(:state_content) { File.read(state_file) }
  let(:state_loader) { TrySailBlogNotification::StateLoader.new(state_file) }

  describe '#initialize' do
    context 'Instance of TrySailBlogNotification::StateLoader' do
      it { expect(state_loader).to(be_a(TrySailBlogNotification::StateLoader)) }
    end
  end

  describe '#to_json' do
    context 'return String' do
      it { expect(state_loader.to_json).to(be_a(String)) }
    end

    context 'eql json' do
      it { expect(state_loader.to_json).to(eql(state_content)) }
    end
  end

  describe '#to_h' do
    let(:hash) { state_loader.to_h }

    context 'return Hash' do
      it { expect(hash).to(be_a(Hash)) }
    end

    context 'have keys' do
      it { expect(hash).to(have_key('Name1')) }
      it { expect(hash).to(have_key('Name2')) }
      it { expect(hash).to(have_key('Name3')) }
    end
  end

  describe '#states' do
    let(:states) { state_loader.states }

    context 'return Hash' do
      it { expect(states).to(be_a(Hash)) }
    end

    context 'have keys' do
      it { expect(states).to(have_key('Name1')) }
      it { expect(states).to(have_key('Name2')) }
      it { expect(states).to(have_key('Name3')) }
    end

    context 'have TrySailBlogNotification::LastArticle' do
      it { expect(states['Name1']).to(be_a(TrySailBlogNotification::LastArticle)) }
      it { expect(states['Name2']).to(be_a(TrySailBlogNotification::LastArticle)) }
      it { expect(states['Name3']).to(be_a(TrySailBlogNotification::LastArticle)) }
    end

    context 'eql title' do
      it { expect(states['Name1'].title).to(eql('hoge')) }
    end

    context 'eql url' do
      it { expect(states['Name1'].url).to(eql('https://tsbn.test/hoge')) }
    end

    context 'eql last_update' do
      it { expect(states['Name1'].last_update).to(eql('Sun, 01 Apr 2018 22:07:28 +0900')) }
    end
  end

end