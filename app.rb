require 'yaml'
require 'pp'

ENV['BUNDLE_GEMFILE'] = File.join(File.dirname(__FILE__), 'Gemfile')

require 'bundler'
Bundler.require

require File.join(File.dirname(__FILE__), '/lib/blog_notification.rb')

config = YAML.load_file(File.join(File.dirname(__FILE__), '/config/config.yml'))

app = BlogNotification::Application.new(
  File.expand_path(File.dirname(__FILE__)),
  config
)

app.load_plugins

app.run
