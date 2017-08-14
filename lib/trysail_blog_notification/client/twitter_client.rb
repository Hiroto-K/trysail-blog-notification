module TrySailBlogNotification::Client
  class TwitterClient < BaseClient

    # Initialize application.
    #
    # @param [TrySailBlogNotification::Application] app
    # @param [Hash] config
    def initialize(app, config)
      @app = app
      @config = config
      @client = Twitter::REST::Client.new(@config)
    end


    # Update.
    #
    # @param [String] name
    # @param [Hash] status
    def update(name, status)
      title = status['title']
      url = status['url']
      last_update = status['last_update']
      sys_date = Time.now.to_s

      text = "【ブログ更新 #{last_update}】\n#{name} : #{title}\n#{url}\nsys_date : #{sys_date}"
      @app.log.info(text)
      @client.update(text)
    end

  end
end
