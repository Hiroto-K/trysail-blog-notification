# frozen_string_literal: true

module TrySailBlogNotification
  module Command
    class ClientTestCommand < BaseCommand

      # Start command.
      def start
        client_name = options["client-name"]
        client_attr = find_client(client_name)
        client_class = client_attr[:client]
        client_config = client_attr[:config]
        client = initialize_client(client_class, client_config)

        test_name = build_test_name
        test_data = build_test_data

        test_client(client, test_name, test_data)
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

      # Build test name
      #
      # @return [String]
      def build_test_name
        options["test-name"] || 'Test-name'
      end

      # Build test data
      #
      # @return [TrySailBlogNotification::LastArticle]
      def build_test_data
        title = options['title'] || 'Test title'
        url = options['url'] || 'https://example.com/'
        last_update = options['last-update'] || Time.now.to_s

        TrySailBlogNotification::LastArticle.new(title: title, url: url, last_update: last_update)
      end

      # Initialize client
      #
      # @param client_class [String]
      # @param client_config [Hash]
      # @return [TrySailBlogNotification::Client::BaseClient]
      def initialize_client(client_class, client_config)
        klass = client_class.constantize
        klass.new(client_config)
      end

      # Test client
      #
      # @param client [TrySailBlogNotification::Client::BaseClient]
      # @param test_name [String]
      # @param test_state [TrySailBlogNotification::LastArticle]
      def test_client(client, test_name, test_state)
        class_name = client.class

        logger.info("client : #{class_name}, name : #{test_name}, state : #{test_state.inspect}")
        logger.info("Call #{class_name}#setup")
        client.setup

        logger.info("Call #{class_name}#before_update")
        client.before_update(test_name, test_state)

        logger.info("Call #{class_name}#update")
        client.update(test_name, test_state)
      end

      # Get clients.
      #
      # @return [Hash]
      def get_clients
        app.config.get(:clients)
      end
    end
  end
end