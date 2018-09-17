require 'trysail_blog_notification/config'

describe TrySailBlogNotification::Config do
  let(:default_config) do
    {
      clients: {
        slack: {
          client: 'TrySailBlogNotification::Client::SlackClient',
          config: {
            token: 'test-token',
            channel: 'test-channel'
          }
        }
      },
      data: {
        log: {
          file: 'log/log.log',
          level: 'debug'
        },
        dump: {
          file: 'data/dump.json'
        }
      },
      urls: {
        '雨宮天': {
          rss: 'http://feedblog.ameba.jp/rss/ameblo/amamiyasorablog/rss20.xml'
        },
        '麻倉もも': {
          rss: 'http://feedblog.ameba.jp/rss/ameblo/asakuramomoblog/rss20.xml'
        },
        '夏川椎菜': {
          rss: 'http://feedblog.ameba.jp/rss/ameblo/natsukawashiinablog/rss20.xml'
        }
      }
    }.with_indifferent_access
  end

  describe '#initialize' do
    let(:config) { TrySailBlogNotification::Config.new(default_config) }

    it 'instance of TrySailBlogNotification::Config' do
      expect(config).to be_a(TrySailBlogNotification::Config)
    end

    it 'has raw config' do
      expect(config.raw_config).to be_a Hash
    end
  end

  describe '#get' do
    let(:config) { TrySailBlogNotification::Config.new(default_config) }

    context 'no key' do
      it 'return raw config' do
        expect(config.get).to be_a Hash
        expect(config.get).to eq default_config
      end
    end

    context 'by symbol' do
      it 'get clients return class is Hash' do
        expect(config.get(:clients)).to be_a Hash
      end

      it 'get clients return eq Hash' do
        expect(config.get(:clients)).to eq default_config[:clients]
      end

      it 'get not exists key return nil' do
        expect(config.get(:not_exists)).to eq nil
      end
    end

    context 'by string' do
      it 'get clients return class is Hash' do
        expect(config.get('clients')).to be_a Hash
      end

      it 'get clients return eq Hash' do
        expect(config.get('clients')).to eq default_config[:clients]
      end

      it 'get not exists key return nil' do
        expect(config.get('not_exists')).to eq nil
      end
    end

    context 'by string dot' do
      it 'get clients.slack return eq Hash' do
        expect(config.get('clients.slack')).to eq default_config[:clients][:slack]
      end

      it 'get data.log.file return eq Hash' do
        expect(config.get('data.log.file')).to eq default_config[:data][:log][:file]
      end

      it 'get not exists key return nil' do
        expect(config.get('not.exists')).to eq nil
      end

      it 'get not exists key return nil' do
        expect(config.get('data.not.exists')).to eq nil
      end
    end

    context 'set default value' do
      it 'check default value' do
        expect(config.get('not.exists', 'default_value')).to eq 'default_value'
      end
    end
  end

  describe '#has?' do
    let(:config) { TrySailBlogNotification::Config.new(default_config) }

    context 'by symbol' do
      it 'clients return true' do
        expect(config.has?(:clients)).to be_truthy
      end

      it 'not exists key return false' do
        expect(config.has?(:not_exists)).to be_falsey
      end
    end

    context 'by string' do
      it 'clients return true' do
        expect(config.has?('clients')).to be_truthy
      end

      it 'not exists key return false' do
        expect(config.has?('not_exists')).to be_falsey
      end
    end

    context 'by string dot' do
      it 'clients.slack return true' do
        expect(config.has?('clients.slack')).to be_truthy
      end

      it 'data.log.file return true' do
        expect(config.has?('data.log.file')).to be_truthy
      end

      it 'not exists key return false' do
        expect(config.has?('not.exists')).to be_falsey
      end

      it 'not exists key return false' do
        expect(config.has?('data.not.exists')).to be_falsey
      end
    end
  end

  describe '#[]' do
    let(:config) { TrySailBlogNotification::Config.new(default_config) }

    context 'access by symbol' do
      it 'access data return eq value' do
        expect(config[:data]).to eq default_config[:data]
      end
    end

    context 'access by string' do
      it 'access data return eq value' do
        expect(config['data']).to eq default_config[:data]
      end
    end

    context 'access to not exists key' do
      it 'access not exists key by symbol return eq value' do
        expect(config[:not_exists]).to eq nil
      end

      it 'access not exists key by string return eq value' do
        expect(config['not_exists']).to eq nil
      end
    end
  end
end
