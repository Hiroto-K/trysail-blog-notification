require 'net/http'
require 'net/https'
require 'uri'

module TrySailBlogNotification
  class HTTP

    # Target url.
    #
    # @return [String]
    attr_reader :url

    # Target url.
    #
    # @return [URI::HTTP|URI::HTTPS]
    attr_reader :uri

    # Request.
    #
    # @return [Net::HTTP::Get]
    attr_reader :request

    # Net::HTTP instance.
    #
    # @return [Net::HTTP]
    attr_reader :http

    # Response instance.
    #
    # @return [Net::HTTPResponse]
    attr_reader :response

    # Html.
    #
    # @return [String]
    attr_reader :html

    # Initialize HTTP class.
    #
    # @param [String] url Target url.
    def initialize(url)
      @url = url
      @uri = URI.parse(URI.encode(@url))
      @request = Net::HTTP::Get.new(@uri.path)
      @http = Net::HTTP.new(@uri.host, @uri.port)
    end

    # Send request.
    #
    # @return [Net::HTTPResponse]
    def request
      @response = get_response
      @html = @response.body

      @response
    end

    private

    # Get response.
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