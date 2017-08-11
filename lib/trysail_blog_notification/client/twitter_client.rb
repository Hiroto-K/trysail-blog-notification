module TrySailBlogNotification::Client
  class TwitterClient < BaseClient

    def initialize(config)
      @config = config
      @client = Twitter::REST::Client.new(@config)
    end

    def update(name, status)
      title = status['title']
      url = status['url']
      last_update = status['last_update']
      sys_date = Time.now.to_s

      text = "【ブログ更新 #{last_update}】\n#{name} : #{title}\n#{url}\nsys_date : #{sys_date}"
      puts text
      @client.update(text)
    end

  end
end
