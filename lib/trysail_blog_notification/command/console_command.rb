# frozen_string_literal: true

module TrySailBlogNotification::Command
  class ConsoleCommand < BaseCommand

    # Start command.
    def start
      Pry.start
    end

  end
end