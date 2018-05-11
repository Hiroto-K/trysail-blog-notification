# frozen_string_literal: true

module TrySailBlogNotification::Command
  class ClientTestCommand < BaseCommand

    # Start command.
    def start
      name = args[:name]
      client = find_client(name)
    end

    private

    # Find client
    #
    # @param name [String]
    # @return [Array]
    def find_client(name)
      clients = get_clients
      raise "Client '#{name}' not found." if clients[name].nil?
      clients[name]
    end

    # Get clients.
    #
    # @return [Hash]
    def get_clients
      app.config.get(:client)
    end

  end
end