---
layout: default
title: blog-notification
---

# blog-notification

ブログの更新通知をTwitterやSlackで受け取るアプリ。

## Install

### Requirement

- Ruby 2.4.0 以降
- Git

### Install

GitHubからソースコードを持ってきて``bundle install``で依存ライブラリをインストール。

```bash
git clone git@github.com:hiroxto/blog-notification.git
cd blog-notification
bundle install
```

### Configure

``config/config.example.yml``を``config/config.yml``へコピーして、ファイルの中に書いてある通りに設定。

## Execute

``ruby app.rb start``で実行。初回はデータを取得して書き込みのみ。2回目以降は前回取得のデータと比較して、更新があった場合のみ通知を送ります。

## License

[MIT License](https://github.com/hiroxto/blog-notification/blob/master/LICENSE "MIT License")