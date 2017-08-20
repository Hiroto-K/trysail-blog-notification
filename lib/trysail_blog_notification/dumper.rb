require 'json'

module TrySailBlogNotification
  class Dumper

    attr_reader :file
    attr_reader :statuses
    attr_reader :json_statuses

    def initialize(file)
      @file = file
    end

    def dump(statuses)
      @statuses = statuses
      @json_statuses = JSON.pretty_generate(@statuses)
      File.open(@file, 'w') do |f|
        f.write(@json_statuses)
      end
    end

  end
end