require 'net/http'
require 'net/https'
require 'uri'

module TrySailBlogNotification
  class HTTP

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
      request = Net::HTTP::Get.new(@uri.path)
      http = Net::HTTP.new(@uri.host, @uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http.start do |h|
        h.request(request)
      end
    end

  end
end