ENV['BUNDLE_GEMFILE'] = File.join(File.dirname(__FILE__), 'Gemfile')

require 'bundler'
Bundler.require(:default, :test)

require File.join(File.dirname(__FILE__), '/lib/trysail_blog_notification.rb')
require File.join(File.dirname(__FILE__), '/test/trysail_blog_notification.rb')

Dir['./test/**/*.rb'].sort.each(&method(:require))