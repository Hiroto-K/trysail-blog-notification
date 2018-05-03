# frozen_string_literal: true

module TrySailBlogNotification::Client
  class TwitterClient < BaseClient

    # Setup.
    def setup
      twitter_config = config.slice(:consumer_key, :consumer_secret, :access_token, :access_token_secret)
      @client = Twitter::REST::Client.new(twitter_config)
    end

    # Update.
    #
    # @param name [String]
    # @param status [TrySailBlogNotification::LastArticle]
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
