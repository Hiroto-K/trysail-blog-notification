# frozen_string_literal: true

module TrySailBlogNotification
  module Command
    class ConsoleCommand < BaseCommand

      # Start command.
      def start
        Pry.start
      end

    end
  end
end