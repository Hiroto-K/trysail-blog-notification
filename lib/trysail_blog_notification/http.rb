require 'net/http'
require 'net/https'
require 'uri'

module TrySailBlogNotification
  module HTTP

    def initialize(url)
      @url = url
      @uri = URI.parse(URI.encode(@url))
      @response = get_response
    end

    attr_reader :url, :uri, :response

    private

    def get_response
      case @uri.scheme
        when 'http' then
          get_http
        when 'https' then
          get_https
        else
      end
    end

    def get_http
      request = Net::HTTP::Get.new(@uri.path)
      http = Net::HTTP.new(@uri.host, @uri.port)
      http.start do |h|
        h.request(request)
      end
    end

    def get_https
    end

  end
end