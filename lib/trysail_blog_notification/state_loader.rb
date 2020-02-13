# frozen_string_literal: true

require 'json'

module TrySailBlogNotification
  class StateLoader

    # JSON file path.
    #
    # @return [String]
    attr_reader :file

    # JSON string.
    #
    # @return [String]
    attr_reader :json

    # Raw states.
    #
    # @return [Hash]
    attr_reader :raw_states

    # States.
    #
    # @return [Hash]
    attr_reader :states

    # Initialize StateLoader.
    #
    # @param file [String] JSON file path.
    def initialize(file)
      @file = file
      load_states
    end

    # To json
    #
    # @return [String]
    def to_json
      @json
    end

    # To hash
    #
    # @return [Hash]
    def to_h
      @raw_states
    end

    private

    # Load data
    def load_states
      @json = File.open(@file, 'r') do |f|
        f.read
      end
      @raw_states = JSON.parse(@json)
      @states = {}

      @raw_states.each do |name, state|
        symbol_state = state.symbolize_keys
        @states[name] = TrySailBlogNotification::LastArticle.new(**symbol_state)
      end
    end

  end
end