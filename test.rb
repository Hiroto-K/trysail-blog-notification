ENV['BUNDLE_GEMFILE'] = File.join(File.dirname(__FILE__), 'Gemfile')

require 'bundler'
Bundler.require(:default, :test)

Dir['./test/**/*.rb'].sort.each(&method(:require))