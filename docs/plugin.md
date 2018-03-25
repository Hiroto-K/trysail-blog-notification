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

It's not read yet.