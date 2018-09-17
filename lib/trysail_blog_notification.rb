# frozen_string_literal: true

module TrySailBlogNotification
end

require File.join(File.dirname(__FILE__), '/trysail_blog_notification/application.rb')
require File.join(File.dirname(__FILE__), '/trysail_blog_notification/util.rb')

Dir[File.join(File.dirname(__FILE__), '/**/*.rb')].sort.each do |file|
  require file
end
