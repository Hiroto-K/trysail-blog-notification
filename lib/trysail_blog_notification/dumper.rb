require 'json'

module TrySailBlogNotification
  class Dumper

    attr_reader :file
    attr_reader :data
    attr_reader :json_data

    def initialize(file)
      @file = file
    end

    def dump(data)
      @data = data
      @json_data = JSON.pretty_generate(@data)
      File.open(@file, 'w') do |f|
        f.write(@json_data)
      end
    end

  end
end