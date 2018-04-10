module TrySailBlogNotification
  module Plugins

    module Client
      class BaseClient < TrySailBlogNotification::Client::BaseClient
      end
    end

    module Parser
      class BaseParser < TrySailBlogNotification::Parser::BaseParser
      end
    end

  end
end