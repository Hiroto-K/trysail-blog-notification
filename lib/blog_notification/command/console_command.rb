# frozen_string_literal: true

module BlogNotification::Command
  class ConsoleCommand < BaseCommand

    # Start command.
    def start
      Pry.start
    end

  end
end