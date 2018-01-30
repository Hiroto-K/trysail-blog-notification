module TrySailBlogNotification::Command
  class StartCommand

    def initialize
      @application = TrySailBlogNotification::Application.app
      @config = @application.config
      @dump_file = @application.dump_file
      @log = @application.log
      @clients = @application.clients
      @urls = @application.urls
    end

    def start
      @log.logger.info("Call \"#{__method__}\" method.")

      current_statuses = {}

      @urls.each do |name, info|
        url = info['url']
        parser_class = info['parser']

        @log.logger.info("Run \"#{name}\" : \"#{url}.\"")

        @log.logger.info('Get response.')

        http = TrySailBlogNotification::HTTP.new(url)

        @log.logger.info(http.response)
        raise "Response http code : '#{http.response.code}'." unless http.response.code == '200'

        html = http.html
        nokogiri = Nokogiri::HTML.parse(html)
        last_article = get_last_article(nokogiri, parser_class)

        @log.logger.info(last_article)

        current_statuses[name] =last_article
      end

      @log.logger.info('current_statuses')
      @log.logger.info(current_statuses)

      check_diff(current_statuses)

      dump_to_file(current_statuses)
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
      @log.logger.info('Get last articles.')

      parser = klass.new(@application, @config)
      parser.parse(nokogiri)
    end

    # Check updates.
    #
    # @param [Hash] current_statuses
    def check_diff(current_statuses)
      @log.logger.info('Check diff.')

      unless File.exists?(@dump_file)
        @log.logger.info("File \"#{@dump_file}\" is not exits.")
        @log.logger.info('Skip check.')
        return
      end

      @log.logger.info("Open dump file : \"#{@dump_file}\".")
      json = File.open(@dump_file, 'r') { |f| f.read }
      old_statuses = JSON.parse(json)

      old_statuses.each do |name, old_status|
        @log.logger.info("Check diff of \"#{name}\".")

        new_status = current_statuses[name]
        unless new_status['url'] == old_status['url'] || new_status['last_update'] == old_status['last_update']
          @log.logger.info("Call \"run_notification\".")
          run_notification(name, new_status)
        end
      end
    end

    # Check updates.
    #
    # @param [String] name
    # @param [TrySailBlogNotification::LastArticle] status
    def run_notification(name, status)
      @log.logger.info("Run notification of \"#{name}\".")

      @clients.each do |client|
        begin
          @log.logger.info("Call \"update\" method of \"#{client.class}\".")
          client.update(name, status)
        rescue Exception => e
          @log.logger.error(e)
        end
      end
    end

    # Write to dump file.
    #
    # @param [Hash] statuses
    def dump_to_file(statuses)
      hashed_statuses = {}
      statuses.each do |name, last_article|
        hashed_statuses[name] = last_article.to_h
      end

      @log.logger.info('Write to dump file.')
      dumper = TrySailBlogNotification::Dumper.new(@dump_file)

      @log.logger.info('Run write.')
      dumper.dump(hashed_statuses)
    end

  end
end