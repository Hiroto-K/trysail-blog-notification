require 'fileutils'
require 'open-uri'

module TrySailBlogNotification
  class Application

    # Base dir
    #
    # @return String
    attr_reader :base_dir

    # Config
    #
    # @return Hash
    attr_reader :config

    # Dump file path.
    #
    # @return String
    attr_reader :dump_file

    # Logger
    #
    # @return TrySailBlogNotification::Log
    attr_reader :log

    # Client instances.
    #
    # @return Array
    attr_reader :clients

    # Target urls
    #
    # @return Hash
    attr_reader :urls

    # Initialize application.
    #
    # @param [String] base_dir
    # @param [Hash] config
    def initialize(base_dir, config)
      @base_dir = base_dir
      @config = set_config(config)

      @dump_file = @config[:data][:dump][:file]
      log_file = @config[:data][:log][:file]
      log_level = @config[:data][:log][:level]
      @log = TrySailBlogNotification::Log.new(log_file, log_level)

      @log.logger.info('Started application.')

      @clients = []

      @urls = {
        '雨宮天'   => 'https://ameblo.jp/amamiyasorablog',
        '麻倉もも' => 'https://ameblo.jp/asakuramomoblog',
        '夏川椎菜' => 'https://ameblo.jp/natsukawashiinablog',
      }

      begin
        add_clients
      rescue RuntimeError => e
        @log.logger.error(e)
      end
    end

    # Add client.
    #
    # @param [TrySailBlogNotification::Client::BaseClient] client
    def add_client(client)
      raise "Client is not instance of 'TrySailBlogNotification::Client::BaseClient'." unless client.is_a?(TrySailBlogNotification::Client::BaseClient)
      @clients.push(client)
    end

    # Run application.
    def run
      @log.logger.info("Call \"#{__method__}\" method.")

      current_statuses = {}

      @urls.each do |name, url|
        @log.logger.info("Run \"#{name}\" : \"#{url}.\"")

        @log.logger.info('Get response.')

        http = TrySailBlogNotification::HTTP.new(url)

        @log.logger.info(http.response)
        raise "Response http code : '#{http.response.code}'." unless http.response.code == '200'

        html = http.html
        nokogiri = Nokogiri::HTML.parse(html)
        last_articles = get_last_articles(nokogiri)

        @log.logger.info(last_articles)

        current_statuses[name] =last_articles
      end

      @log.logger.info('current_statuses')
      @log.logger.info(current_statuses)

      check_diff(current_statuses)

      dump_to_file(current_statuses)
    rescue RuntimeError => e
      @log.logger.error(e)
    end

    private

    # Set config. Expand file path.
    #
    # @param [Hash] config
    # @return Hash
    def set_config(config)
      config[:data][:log][:file] = File.join(@base_dir, config[:data][:log][:file])
      config[:data][:dump][:file] = File.join(@base_dir, config[:data][:dump][:file])

      config
    end

    # Add clients.
    def add_clients
      add_client(TrySailBlogNotification::Client::TwitterClient.new(self, @config[:client][:twitter]))
      add_client(TrySailBlogNotification::Client::SlackClient.new(self, @config[:client][:slack]))
    end

    # Get last articles.
    #
    # @param [Nokogiri::HTML::Document] nokogiri
    # @return [Hash]
    def get_last_articles(nokogiri)
      @log.logger.info('Get last articles.')

      articles = nokogiri.xpath('//div[@class="skinMainArea2"]/article[@class="js-entryWrapper"]')
      first_article = articles.first

      title_obj = first_article.xpath('//h1/a[@class="skinArticleTitle"]').first
      title = title_obj.children.first.content.strip
      url = title_obj.attributes['href'].value
      last_update = first_article.xpath('//span[@class="articleTime"]//time').first.content

      {
        'title'       => title,
        'url'         => url,
        'last_update' => last_update,
      }
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
        unless new_status['last_update'] == old_status['last_update']
          @log.logger.info("Call \"run_notification\".")
          run_notification(name, new_status)
        end
      end
    end

    # Check updates.
    #
    # @param [String] name
    # @param [Hash] status
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
      @log.logger.info('Write to dump file.')
      dumper = TrySailBlogNotification::Dumper.new(@dump_file)

      @log.logger.info('Run write.')
      dumper.dump(statuses)
    end

  end
end