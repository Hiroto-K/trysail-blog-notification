require 'uri'

module TrySailBlogNotification
  class LastArticle

    # Return title
    #
    # @return [String]
    attr_reader :title

    # Return uri object
    #
    # @return [URI::Generic]
    attr_reader :uri

    # Return url string
    #
    # @return [String]
    attr_reader :url

    # Return last update
    #
    # @return [String]
    attr_reader :last_update

    # Initialize LastArticle.
    #
    # @param [String] title
    # @param [String] url
    # @param [String] last_update
    def initialize(title, url, last_update)
      @title = title
      set_url(url)
      @last_update = last_update
    end

    private

    # Set url
    #
    # @param [String] url
    def set_url(url)
      @uri = URI.parse(url)
      @url = @uri.to_s
    end

  end
end