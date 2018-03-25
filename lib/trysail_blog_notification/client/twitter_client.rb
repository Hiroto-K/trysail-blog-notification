# frozen_string_literal: true

module TrySailBlogNotification::Client
  class TwitterClient < BaseClient

    # Initialize application.
    #
    # @param [Hash] config
    def initialize(config)
      super(config)

      @client = Twitter::REST::Client.new(@config)
    end

    # Update.
    #
    # @param [String] name
    # @param [TrySailBlogNotification::LastArticle] status
    def update(name, status)
      date = Time.now

      text = <<"EOS"
【ブログ更新 #{status.title}】
#{name} : #{status.title}
#{status.url}
date : #{date}
EOS
      logger.info(text)
      @client.update(text)
    end

  end
end
