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

      rm(files)
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
    # @return [Array]
    def rm(files)
      FileUtils.rm(files, verbose: true, force: false)
    end

  end
end