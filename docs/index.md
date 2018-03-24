# trysail-blog-notification

TrySailのメンバーのブログの更新通知をTwitterやSlackで受け取るアプリ。

プラグインでの拡張により、TrySailのメンバーのブログ以外も受け取れます。

## Install

### Requirement

- Ruby 2.4.0 以降
- Git

### Install

GitHubからソースコードを持ってきて``bundle install``で依存ライブラリをインストール。

```bash
git clone git@github.com:Hiroto-K/trysail-blog-notification.git
cd trysail-blog-notification
bundle install
```

### Configure

``config/config.example.yml``を``config/config.yml``へコピーして、ファイルの中に書いてある通りに設定。

## Execute

``ruby app.rb start``で実行。初回はデータを取得して書き込みのみ。2回目以降は前回取得のデータと比較して、更新があった場合のみ通知を送ります。

## Plugins

- [Hiroto-K/tbn-ari-ozawa-plugin](https://github.com/Hiroto-K/tbn-ari-ozawa-plugin)
    - 小澤亜李さんのブログの通知を受け取るプラグイン。
- [Hiroto-K/tbn-miku-ito-plugin](https://github.com/Hiroto-K/tbn-miku-ito-plugin)
    - 伊藤美来さんのブログの通知を受け取るプラグイン。
- [Hiroto-K/tbn-moe-toyota-plugin](https://github.com/Hiroto-K/tbn-moe-toyota-plugin)
    - 豊田萌絵さんのブログの通知を受け取るプラグイン。

## License

[MIT License](https://github.com/Hiroto-K/trysail-blog-notification/blob/master/LICENSE "MIT License")