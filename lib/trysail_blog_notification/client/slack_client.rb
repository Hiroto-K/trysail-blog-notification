# frozen_string_literal: true

module TrySailBlogNotification::Client
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
    # @param status [TrySailBlogNotification::LastArticle]
    def before_update(name, status)
      @client.auth_test
    end

    # Update.
    #
    # @param name [String]
    # @param status [TrySailBlogNotification::LastArticle]
    def update(name, status)
      date = Time.now

      text = <<"EOS"
#{name}のブログが更新されました。

#{status.title}
#{status.url}

ブログ更新時刻 : #{status.last_update}
システム時刻   : #{date}
EOS

      logger.info(text)
      @client.chat_postMessage(channel: config[:channel], text: text, as_user: true)
    end

  end
end