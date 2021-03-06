---
layout: default
title: Plugin
---

# blog-notification plugin

ここではプラグインの作成方法を説明します。

## Plugin file

読み込まれるファイルは``plugin/[plugin-name]/[plugin-name].rb``ファイルのみです。(例 : ``plugin/test-plugin/test-plugin.rb``)

別途読み込む必要があるファイルがある場合は、自動で読み込まれるファイルの中で読み込む必要があります。

プラグインは``BlogNotification::Application#.load_plugins``が呼ばれたタイミングで、アルファベット順に読み込まれます。

### Gemfile

別途gemを利用する場合は``plugin/[plugin-name]/Gemfile``を作れば、blog-notificationの``Gemfile``より``eval_gemfile``で読み込みます。この際プラグイン側に``Gemfile.lock``は必要ではありません。

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

## Client plugin

通知を送るクライアントのプラグインの作成方法。

``BlogNotification::Client::BaseClient``を継承したクラスを作成します。

```ruby
module Hoge
  class FooClient < BlogNotification::Client::BaseClient

      # クライアントの初期化時に呼ばれます。
      def setup
        puts "setup"
      end

      # updateメソッドを呼ぶ前に呼ばれます。
      #
      # @param name [String]
      # @param article [BlogNotification::LastArticle]
      def before_update(name, article)
        puts "before_update"
      end

      # 通知を送信するメソッド。実装が必須。
      #
      # @param name [String]
      # @param article [BlogNotification::LastArticle]
      def update(name, article)
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