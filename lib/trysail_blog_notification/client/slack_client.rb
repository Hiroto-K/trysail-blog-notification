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
      @client.auth_test
    end

    # Update.
    #
    # @param [String] name
    # @param [TrySailBlogNotification::LastArticle] status
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
      @client.chat_postMessage(channel: @config['channel'], text: text, as_user: true)
    end

  end
end