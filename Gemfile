source 'https://rubygems.org'

gem 'pry', '~>0.10'
gem 'activesupport', '~>5.1', :require => %w(active_support active_support/core_ext active_support/logger)
gem 'thor', '~>0.20'
gem 'faraday', '~>0.14'
gem 'nokogiri', '~>1.8'
gem 'twitter', '~>6.1'
gem 'slack-ruby-client', '~>0.8'

group :test do
  gem 'rspec', '~>3.7'
end

group :plugin do
  Dir.glob(File.join(File.dirname(__FILE__), "/plugin/*/Gemfile")).sort.each do |path|
    eval_gemfile path
  end
end