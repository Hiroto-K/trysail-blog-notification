require 'fileutils'
require 'open-uri'

module TrySailBlogNotification
  class Application

    attr_writer :log_file, :dump_file

    attr_reader :log_file, :dump_file

    def initialize(file)
      @file = File.expand_path(file)
      @clients = []

      @urls = {
        '雨宮天'   => 'http://ameblo.jp/amamiyasorablog',
        '麻倉もも' => 'http://ameblo.jp/asakuramomoblog',
        '夏川椎菜' => 'http://ameblo.jp/natsukawashiinablog',
      }
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
      return unless File.exists?(@file)

      json = File.open(@file, 'r') { |f| f.read }
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

      File.open(@file, 'w') do |f|
        f.write(info)
      end
    end

  end
end