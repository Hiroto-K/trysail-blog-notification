require 'yaml'
require 'pp'

ENV['BUNDLE_GEMFILE'] = File.join(File.dirname(__FILE__), 'Gemfile')

require 'bundler'
Bundler.require

require File.join(File.dirname(__FILE__), '/lib/trysail_blog_notification.rb')

config = YAML.load_file(File.join(File.dirname(__FILE__), '/config/config.yml'))

twitter_client = TrySailBlogNotification::Client::TwitterClient.new(config[:twitter])
slack_client = TrySailBlogNotification::Client::SlackClient.new(config[:slack])

app = TrySailBlogNotification::Application.new(
  File.join(File.dirname(__FILE__), '/data/dump.json'),
  File.join(File.dirname(__FILE__), '/data/log.log')
)
app.add_client(twitter_client)
app.add_client(slack_client)

app.run
