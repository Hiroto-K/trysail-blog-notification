module TrySailBlogNotification::Client
  class SlackClient < BaseClient

    # Initialize application.
    #
    # @param [TrySailBlogNotification::Application] app
    # @param [Hash] config
    def initialize(app, config)
      super(app, config)

      Slack.configure do |c|
        c.token = @config[:token]
      end

      @client = Slack::Web::Client.new
      @client.auth_test
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

      text = <<"EOS"
#{name}のブログが更新されました。

#{title}
#{url}

ブログ更新時刻 : #{last_update}
システム時刻   : #{sys_date}
EOS

      @app.log.info(text)
      @client.chat_postMessage(channel: @config[:channel], text: text, as_user: true)
    end

  end
end