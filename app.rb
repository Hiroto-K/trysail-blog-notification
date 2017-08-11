require 'yaml'
require 'pp'
require 'bundler'
Bundler.require

require File.join(File.dirname(__FILE__), '/lib/trysail_blog_notification.rb')

config = YAML.load_file(File.expand_path('./config/config.yml'))

twitter_client = TrySailBlogNotification::Client::TwitterClient.new(config[:twitter])
slack_client = TrySailBlogNotification::Client::SlackClient.new(config[:slack])

app = TrySailBlogNotification::Application.new(File.expand_path('data/dump.json'))
app.add_client(twitter_client)
app.add_client(slack_client)
app.run
