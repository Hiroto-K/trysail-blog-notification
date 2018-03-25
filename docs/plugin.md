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

## Parser plugin

It's not read yet.

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