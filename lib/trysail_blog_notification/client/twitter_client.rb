module TrySailBlogNotification::Client
  class TwitterClient < BaseClient

    # Initialize application.
    #
    # @param [TrySailBlogNotification::Application] app
    # @param [Hash] config
    def initialize(app, config)
      super(app, config)

      @client = Twitter::REST::Client.new(@config)
    end

    # Update.
    #
    # @param [String] name
    # @param [TrySailBlogNotification::LastArticle] status
    def update(name, status)
      super(name, status)

      text = "【ブログ更新 #{@last_update}】\n#{name} : #{@title}\n#{@url}\nsys_date : #{@sys_date}"
      @app.log.info(text)
      @client.update(text)
    end

  end
end
