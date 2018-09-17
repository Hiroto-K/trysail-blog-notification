# frozen_string_literal: true

module TrySailBlogNotification
  module Client
    class TwitterClient < BaseClient

      # Setup.
      def setup
        twitter_config = config.slice(:consumer_key, :consumer_secret, :access_token, :access_token_secret)
        @client = Twitter::REST::Client.new(twitter_config)
      end

      # Update.
      #
      # @param name [String]
      # @param article [TrySailBlogNotification::LastArticle]
      def update(name, article)
        date = Time.now

        text = <<"EOS"
【ブログ更新 #{article.title}】
#{name} : #{article.title}
        #{article.url}
date : #{date}
EOS
        logger.info(text)
        @client.update(text)
      end

    end
  end
end
