require 'fileutils'
require 'open-uri'

module TrySailBlogNotification
  class Application

    # Dump file path.
    #
    # @return String
    attr_reader :dump_file

    # Logger
    #
    # @return TrySailBlogNotification::Log
    attr_reader :log

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
        '雨宮天'   => 'http://ameblo.jp/amamiyasorablog',
        '麻倉もも' => 'http://ameblo.jp/asakuramomoblog',
        '夏川椎菜' => 'http://ameblo.jp/natsukawashiinablog',
      }

      add_clients
    end

    def set_config(config)
      config[:data][:log][:file] = File.join(@base_dir, config[:data][:log][:file])
      config[:data][:dump][:file] = File.join(@base_dir, config[:data][:dump][:file])

      config
    end

    def add_clients
      add_client(TrySailBlogNotification::Client::TwitterClient(@config[:client][:twitter]))
      add_client(TrySailBlogNotification::Client::SlackClient(@config[:client][:slack]))
    end

    def add_client(client)
      raise "Client is not instance of 'Client::BaseClient'." unless client.is_a?(Client::BaseClient)
      @clients.push(client)
    end

    def run
      current_statuses = {}

      @urls.each do |name, url|
        http = TrySailBlogNotification::HTTP.new(url)
        html = http.html
        nokogiri = Nokogiri::HTML.parse(html)
        last_articles = get_last_articles(nokogiri)
        current_statuses[name] =last_articles
      end

      check_diff(current_statuses)
      write_to_file(current_statuses)
    end

    def get_last_articles(nokogiri)
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

    def check_diff(current_statuses)
      return unless File.exists?(@dump_file)

      json = File.open(@dump_file, 'r') { |f| f.read }
      old_statuses = JSON.parse(json)

      old_statuses.each do |name, old_status|
        new_status = current_statuses[name]
        unless new_status['last_update'] == old_status['last_update']
          run_notification(name, new_status)
        end
      end
    end

    def run_notification(name, status)
      @clients.each do |client|
        client.update(name, status)
      end
    end

    def write_to_file(statuses)
      info = JSON.pretty_generate(statuses)

      File.open(@dump_file, 'w') do |f|
        f.write(info)
      end
    end

  end
end