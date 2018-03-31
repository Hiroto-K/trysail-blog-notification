# frozen_string_literal: true

require 'fileutils'

module TrySailBlogNotification::Command
  class CleanCommand < BaseCommand

    # Start command.
    def start
      files = []
      files << find_files(app.base_path('data/*'))
      files << find_files(app.base_path('log/*'))
      files.flatten!

      option = options.slice(:verbose, :force).symbolize_keys
      rm(files, option)
    end

    private

    # Find files.
    #
    # @param [Array] pattern
    # @return [Array]
    def find_files(pattern)
      Dir.glob(pattern)
    end

    # Delete files
    #
    # @param [Array] files
    # @param [Hash] options
    # @return [Array]
    def rm(files, options)
      FileUtils.rm(files, options)
    end

  end
end