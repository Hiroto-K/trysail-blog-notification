# frozen_string_literal: true

module TrySailBlogNotification
  module Client
    class SlackClient < BaseClient

      # Setup.
      def setup
        Slack.configure do |c|
          c.token = config[:token]
        end

        @client = Slack::Web::Client.new
        @client.logger = logger
      end

      # Before update.
      #
      # @param name [String]
      # @param article [TrySailBlogNotification::LastArticle]
      def before_update(name, article)
        @client.auth_test
      end

      # Update.
      #
      # @param name [String]
      # @param article [TrySailBlogNotification::LastArticle]
      def update(name, article)
        format = '%Y-%m-%d %T %:z'
        system_date = Time.now.strftime(format)
        article_last_update = article.last_update.strftime(format)

        text = <<"EOS"
#{name}のブログが更新されました。

#{article.title}
        #{article.url}

ブログ更新時刻 : #{article_last_update}
システム時刻   : #{system_date}
EOS

        logger.info(text)
        @client.chat_postMessage(channel: config[:channel], text: text, as_user: true)
      end
    end
  end
end
