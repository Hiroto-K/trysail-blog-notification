# frozen_string_literal: true

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

      text = <<"EOS"
【ブログ更新 #{@last_update}】
#{name} : #{@title}
#{@url}
sys_date : #{@sys_date}
EOS
      @app.log.info(text)
      @client.update(text)
    end

  end
end
