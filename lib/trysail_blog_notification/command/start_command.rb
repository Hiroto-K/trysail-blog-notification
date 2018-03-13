# frozen_string_literal: true

module TrySailBlogNotification::Command
  class StartCommand < BaseCommand

    # Initialize StartCommand
    #
    # @param [Hash] options
    # @param [Array] args
    def initialize(options, args)
      super(options, args)

      @application = app
      @config = @application.config
      @dump_file = @application.dump_file
      @log = @application.log
      @clients = @application.clients
      @urls = @application.urls
    end

    # Start command.
    def start
      @log.logger.debug("Call \"#{__method__}\" method.")

      current_states = {}

      @urls.each do |name, info|
        url = info['url']
        parser_class = info['parser']

        @log.logger.debug("Run \"#{name}\" : \"#{url}.\"")

        @log.logger.debug('Get response.')

        http = TrySailBlogNotification::HTTP.new(url)
        http.request

        @log.logger.debug(http.response)
        raise "Response http code : '#{http.response.code}'." unless http.response.code == '200'

        html = http.html
        nokogiri = Nokogiri::HTML.parse(html)
        last_article = get_last_article(nokogiri, parser_class)

        @log.logger.debug(last_article)

        current_states[name] =last_article
      end

      @log.logger.debug('current_states')
      @log.logger.debug(current_states)

      check_diff(current_states)

      dump_to_file(current_states)
    rescue RuntimeError => e
      @log.logger.error(e)
    end

    private

    # Get last article.
    #
    # @param [Nokogiri::HTML::Document] nokogiri
    # @param [TrySailBlogNotification::Parser::BaseParser] klass
    # @return [TrySailBlogNotification::LastArticle]
    def get_last_article(nokogiri, klass)
      @log.logger.debug('Get last articles.')

      parser = klass.new(@config)
      parser.parse(nokogiri)
    end

    # Check updates.
    #
    # @param [Hash] current_states
    def check_diff(current_states)
      @log.logger.debug('Check diff.')

      unless File.exists?(@dump_file)
        @log.logger.debug("File \"#{@dump_file}\" is not exits.")
        @log.logger.debug('Skip check.')
        return
      end

      old_states = get_old_states

      old_states.each do |name, old_state|
        @log.logger.debug("Check diff of \"#{name}\".")

        if current_states[name].nil?
          @log.logger.info("current_states[#{name}] is nil. Skip check diff.")
          next
        end

        new_state = current_states[name]
        unless new_state['url'] == old_state['url'] || new_state['last_update'] == old_state['last_update']
          if options['no-notification']
            @log.logger.info('Option "--no-notification" is enabled. No send the notification.')
          else
            @log.logger.debug("Call \"run_notification\".")
            run_notification(name, new_state)
          end
        end
      end
    end

    # Get old state.
    #
    # @return [Hash]
    def get_old_states
      @log.logger.debug("Open dump file : \"#{@dump_file}\".")
      loader = TrySailBlogNotification::StateLoader.new(@dump_file)
      loader.states
    end

    # Check updates.
    #
    # @param [String] name
    # @param [TrySailBlogNotification::LastArticle] state
    def run_notification(name, state)
      @log.logger.debug("Run notification of \"#{name}\".")

      @clients.each do |client|
        begin
          @log.logger.debug("Call \"update\" method of \"#{client.class}\".")
          client.update(name, state)
        rescue Exception => e
          @log.logger.error("Raised exception in #{client.class}#.update")
          @log.logger.error(e)
        end
      end
    end

    # Write to dump file.
    #
    # @param [Hash] states
    def dump_to_file(states)
      hashed_states = {}
      states.each do |name, last_article|
        hashed_states[name] = last_article.to_h
      end

      @log.logger.debug('Write to dump file.')
      dumper = TrySailBlogNotification::StateDumper.new(@dump_file)

      @log.logger.debug('Run write.')
      dumper.dump(hashed_states)
    end

  end
end