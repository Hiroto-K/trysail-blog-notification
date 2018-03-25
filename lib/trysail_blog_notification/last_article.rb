# frozen_string_literal: true

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
    def initialize(title:, url:, last_update:)
      @title = title
      set_url(url)
      @last_update = last_update
    end

    # Convert to Hash.
    #
    # @return [Hash]
    def to_h
      {
        title: @title,
        url: @url,
        last_update: @last_update,
      }
    end

    alias_method :to_hash, :to_h

    # Get hash object
    #
    # @param [Object] key
    # @return [Object]
    def [](key)
      case key
        when 'title', :title
          @title
        when 'url', :url
          @url
        when 'last_update', :last_update
          @last_update
        else
          nil
      end
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