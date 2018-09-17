require 'yaml'
require 'pp'

ENV['BUNDLE_GEMFILE'] = File.join(File.dirname(__FILE__), 'Gemfile')

require 'bundler'
Bundler.require

require File.join(File.dirname(__FILE__), '/lib/trysail_blog_notification.rb')

config = YAML.load_file(File.join(File.dirname(__FILE__), '/config/config.yml'))

app = TrySailBlogNotification::Application.new(
  __dir__,
  config
)

app.load_plugins

app.run
