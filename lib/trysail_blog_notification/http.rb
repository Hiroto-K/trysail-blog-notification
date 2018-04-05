# frozen_string_literal: true

module TrySailBlogNotification
  class HTTP

    # Target url.
    #
    # @return [String]
    attr_reader :url

    # Request.
    #
    # @return [Faraday::Connection]
    attr_reader :faraday_connection

    # Response instance.
    #
    # @return [Faraday::Response]
    attr_reader :response

    # Response body.
    #
    # @return [String]
    attr_reader :body

    # Initialize HTTP class.
    #
    # @param [String] url Target url.
    def initialize(url)
      @url = url
      @faraday_connection = Faraday::Connection.new(url: @url) do |faraday|
        faraday.adapter Faraday.default_adapter
      end
    end

    # Send request.
    #
    # @return [Faraday::Response]
    def request
      @response = @faraday_connection.get
      @body = @response.body

      @response
    end

    # Check request was success.
    #
    # @return [TrueClass|FalseClass]
    def success?
      @response.success?
    end

  end
end