require 'json'

module TrySailBlogNotification
  class Dumper

    # Dump file path.
    #
    # @return String
    attr_reader :file

    # Statuses.
    #
    # @return Hash
    attr_reader :statuses

    # JSON statuses.
    #
    # @return String
    attr_reader :json_statuses

    # Initialize dumper.
    #
    # @param [String] file Dump file path.
    def initialize(file)
      @file = file
    end

    # Dump to file.
    #
    # @param [Hash] statuses Current statues.
    def dump(statuses)
      @statuses = statuses
      @json_statuses = JSON.pretty_generate(@statuses)
      File.open(@file, 'w') do |f|
        f.write(@json_statuses)
      end
    end

  end
end