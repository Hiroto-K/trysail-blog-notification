module TrySailBlogNotification
  module HTTP

    def initialize(url)
      @url = url
      @response = get_response
    end

    attr_reader :url, :response

    private

    def get_response
    end

  end
end