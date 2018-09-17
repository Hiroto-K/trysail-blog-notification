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
    # @return [Time]
    attr_reader :last_update

    # Initialize LastArticle.
    #
    # @param title [String] Article title.
    # @param url [String] Article url.
    # @param last_update [Time, String] Article update at.
    def initialize(title:, url:, last_update:)
      @title = title
      set_url(url)

      last_update = Time.parse(last_update.to_s) unless last_update.is_a?(Time)
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

    alias to_hash to_h

    # Get hash object
    #
    # @param key [String, Symbol]
    # @return [Object]
    def [](key)
      case key
      when 'title', :title
        @title
      when 'url', :url
        @url
      when 'last_update', :last_update
        @last_update
      end
    end

    private

    # Set url
    #
    # @param url [String]
    def set_url(url)
      @uri = URI.parse(url)
      @url = @uri.to_s
    end
  end
end
