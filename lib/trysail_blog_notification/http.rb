require 'net/http'
require 'net/https'
require 'uri'

module TrySailBlogNotification
  class HTTP

    def initialize(url)
      @url = url
      @uri = URI.parse(URI.encode(@url))
      @request = Net::HTTP::Get.new(@uri.path)
      @http = Net::HTTP.new(@uri.host, @uri.port)

      @response = get_response
      @html = @response.body
    end

    attr_reader :url, :uri, :request, :http, :response, :html

    private

    def get_response
      if @uri.scheme == 'https'
        @http.use_ssl = true
        @http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      @http.start do |h|
        h.request(@request)
      end
    end

  end
end