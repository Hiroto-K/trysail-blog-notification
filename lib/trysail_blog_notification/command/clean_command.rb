# frozen_string_literal: true

require 'fileutils'

module TrySailBlogNotification
  module Command
    class CleanCommand < BaseCommand

      # Start command.
      def start
        files = []
        files << find_files(app.base_path('data/*'))
        files << find_files(app.base_path('log/*'))
        files.flatten!

        option = options.slice(:verbose, :force, :noop).symbolize_keys
        rm(files, option)
      end

      private

      # Find files.
      #
      # @param pattern [Array]
      # @return [Array<String>]
      def find_files(pattern)
        Dir.glob(pattern)
      end

      # Delete files
      #
      # @param files [Array<String>]
      # @param option [Hash]
      # @option option [true, false] :force
      # @option option [true, false] :noop
      # @option option [true, false] :verbose
      # @return [Array<String>]
      def rm(files, option)
        FileUtils.rm(files, option)
      end
    end
  end
end
