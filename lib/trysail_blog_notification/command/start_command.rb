# frozen_string_literal: true

module TrySailBlogNotification::Command
  class StartCommand < BaseCommand

    # Set up command class.
    def setup
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
    # @param current_states [Hash]
    def check_diff(current_states)
      logger.debug('Check diff.')

      unless dump_file_exists?
        logger.debug("File \"#{@dump_file}\" is not exits.")
        logger.debug('Skip check.')
        return
      end

      old_states = load_old_states

      old_states.each do |name, old_state|
        logger.debug("Check diff of \"#{name}\".")
        new_state = current_states[name]

        unless new_state.is_a?(TrySailBlogNotification::LastArticle)
          logger.info("current_states[#{name}] a is unsuitable value. Skip check diff.")
          next
        end

        unless eql_article?(old_state, new_state)
          if options['no-notification']
            logger.info('Option "--no-notification" is enabled. No send the notification.')
            next
          end

          run_notification(name, new_state)
        end
      end
    end

    # Check dump file exists.
    #
    # @return [true, false]
    def dump_file_exists?
      File.exists?(@dump_file)
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
    # @param old_article [TrySailBlogNotification::LastArticle]
    # @param new_article [TrySailBlogNotification::LastArticle]
    # @return [true, false]
    def eql_article?(old_article, new_article)
      old_article.title == new_article.title || old_article.url == new_article.url
    end

    # Run notification.
    #
    # @param name [String]
    # @param state [TrySailBlogNotification::LastArticle]
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
    # @param states [Hash]
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