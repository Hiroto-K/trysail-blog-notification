---
layout: default
title: Plugin
---

# trysail-blog-notification plugin

ここではプラグインの作成方法を説明します。

## Plugin file

読み込まれるファイルは``plugin/[plugin-name]/[plugin-name].rb``ファイルのみです。(例 : ``plugin/test-plugin/test-plugin.rb``)

別途読み込む必要があるファイルがある場合は、自動で読み込まれるファイルの中で読み込む必要があります。

プラグインは``TrySailBlogNotification::Application#.load_plugins``が呼ばれたタイミングで、アルファベット順に読み込まれます。

### Gemfile

別途gemを利用する場合は``plugin/[plugin-name]/Gemfile``を作れば、trysail-blog-notificationの``Gemfile``より``eval_gemfile``で読み込みます。この際プラグイン側に``Gemfile.lock``は必要ではありません。

## Add new blog

デフォルトで設定されているブログ以外のブログも追加する場合。

RSSが提供されている場合、``config/config.yml``の``urls``にRSSのurlを追加するだけです。
```yaml
urls :
  雨宮天 :
    rss : "http://feedblog.ameba.jp/rss/ameblo/amamiyasorablog/rss20.xml"

  麻倉もも :
    rss : "http://feedblog.ameba.jp/rss/ameblo/asakuramomoblog/rss20.xml"

  夏川椎菜 :
    rss : "http://feedblog.ameba.jp/rss/ameblo/natsukawashiinablog/rss20.xml"

  # 例 https://ameblo.jp/ari-step/ を追加
  小澤亜李 :
    # rssのurlを指定
    rss : "http://feedblog.ameba.jp/rss/ameblo/ari-step/rss20.xml"
```

RSSが提供されていない場合は以下方法のParserプラグインを作成します。

## Parser plugin

ブログの内容をパースするプラグインの作成方法。

通知するブログにRSSがある場合、上記の方法でRSSを追加するべきです。

``TrySailBlogNotification::Plugins::Parser::BaseParser``を継承したクラスを作成します。

```ruby
module Hoge
  class FooParser < TrySailBlogNotification::Plugins::Parser::BaseParser

    # パースを行うメソッド。返り値は必ず TrySailBlogNotification::LastArticle のインスタンスである必要があります。
    # 
    # @param [Nokogiri::HTML::Document] nokogiri
    # @return [TrySailBlogNotification::LastArticle]
    def parse(nokogiri)
      title = get_title
      url = get_url
      last_update = get_last_update

      TrySailBlogNotification::LastArticle.new(title: title, url: url, last_update: last_update)
    end

  end
end
```

### Register parser plugin

``config/config.yml``ファイルの``urls``フィールドに追加します。

```yaml
urls :
  Foo : # URLとパーサー名に付ける名前。他の名前とは被せる事が出来ません。
    url : "https://example.com/" # アクセスするURL
    parser : "Hoge::FooParser" # クラス名
```

## Client plugin

通知を送るクライアントのプラグインの作成方法。

``TrySailBlogNotification::Plugins::Client::BaseClient``を継承したクラスを作成します。

メソッドの使い方と実装が必須かどうか

|メソッド名|呼ばれるタイミング|使い方|実装が必須か|
|:--:|:--:|:--:|:--:|
|``setup``|クライアントの登録時|クラスの初期化||
|``before_update``|``update``メソッドを呼ぶ前|通知の送信の準備||
|``update``|通知を送る時|実際に通知を送る| :red_circle: |

```ruby
module Hoge
  class FooClient < TrySailBlogNotification::Plugins::Client::BaseClient

      def setup
        puts "setup"
      end

      # @param [String] name
      # @param [TrySailBlogNotification::LastArticle] status
      def before_update(name, status)
        puts "before_update"
      end

      # @param [String] name
      # @param [TrySailBlogNotification::LastArticle] status
      def update(name, status)
        puts "update"
      end

  end
end
```

### Register client plugin

``config/config.yml``ファイルの``clients``フィールドに追加します。

```yaml
clients :
  client-uniq-name :
    client : "Hoge::FooClient" # クラス名
    config : # Clientクラスに渡される設定
      key : value
```