# frozen_string_literal: true

module TrySailBlogNotification::Command
  class StartCommand < BaseCommand

    # Initialize StartCommand
    #
    # @param [Hash] options
    # @param [Array] args
    def initialize(options, args)
      super(options, args)

      @dump_file = app.dump_file
      @clients = app.clients
      @urls = app.urls
    end

    # Start command.
    def start
      logger.debug("Call \"#{__method__}\" method.")

      updater = TrySailBlogNotification::StateUpdater.new(@urls)
      updater.update

      current_states = updater.states

      logger.debug('current_states')
      logger.debug(current_states)

      check_diff(current_states)

      dump_to_file(current_states)
    rescue RuntimeError => e
      logger.error(e)
    end

    private

    # Check updates.
    #
    # @param [Hash] current_states
    def check_diff(current_states)
      logger.debug('Check diff.')

      unless File.exists?(@dump_file)
        logger.debug("File \"#{@dump_file}\" is not exits.")
        logger.debug('Skip check.')
        return
      end

      old_states = load_old_states

      old_states.each do |name, old_state|
        logger.debug("Check diff of \"#{name}\".")

        if current_states[name].nil?
          logger.info("current_states[#{name}] is nil. Skip check diff.")
          next
        end

        new_state = current_states[name]
        unless eql_article?(old_state, new_state)
          if options['no-notification']
            logger.info('Option "--no-notification" is enabled. No send the notification.')
          else
            logger.debug("Call \"run_notification\".")
            run_notification(name, new_state)
          end
        end
      end
    end

    # Get old state.
    #
    # @return [Hash]
    def load_old_states
      logger.debug("Open dump file : \"#{@dump_file}\".")
      loader = TrySailBlogNotification::StateLoader.new(@dump_file)
      loader.states
    end

    # Check eql article.
    #
    # @param [TrySailBlogNotification::LastArticle] old_article
    # @param [TrySailBlogNotification::LastArticle] new_article
    # @return [TrueClass|FalseClass]
    def eql_article?(old_article, new_article)
      old_article.title == new_article.title || old_article.url == new_article.url
    end

    # Check updates.
    #
    # @param [String] name
    # @param [TrySailBlogNotification::LastArticle] state
    def run_notification(name, state)
      logger.debug("Run notification of \"#{name}\".")

      @clients.each do |client|
        begin
          logger.debug("Call #{client.class}#before_update")
          client.before_update(name, state)

          logger.debug("Call #{client.class}#update")
          client.update(name, state)
        rescue Exception => e
          logger.error("Raised exception in #{client.class}")
          logger.error(e)
        end
      end
    end

    # Write to dump file.
    #
    # @param [Hash] states
    def dump_to_file(states)
      hashed_states = states.map { |name, last_article|
        [name, last_article.to_h]
      }.to_h

      logger.debug('Write to dump file.')
      dumper = TrySailBlogNotification::StateDumper.new(@dump_file)

      logger.debug('Run write.')
      dumper.dump(hashed_states)
    end

  end
end