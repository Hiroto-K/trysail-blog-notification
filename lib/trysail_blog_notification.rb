module TrySailBlogNotification; end

library_files = Dir[File.join(File.dirname(__FILE__), '/**/*.rb')].sort
library_files.each do |file|
  require file
end