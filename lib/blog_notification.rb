# frozen_string_literal: true

module BlogNotification
end

require File.join(File.dirname(__FILE__), '/blog_notification/application.rb')
require File.join(File.dirname(__FILE__), '/blog_notification/util.rb')

Dir[File.join(File.dirname(__FILE__), '/**/*.rb')].sort.each do |file|
  require file
end