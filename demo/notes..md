# 説明

## ActionCable とは

[Action Cable の概要](https://railsguides.jp/action_cable_overview.html)
WebSocket を利用してサーバーサイドとクライアントサイドで連続的（持続的）な通信

### action cable の構造

![image1](demo/actioncable1.png)

- Channel: 特定の機能やルームを表す論理的なグループ
- Subscription: サブスクライバとチャネルの間のコネクション
- Consumer: クライアント側で WebSocket に接続するオブジェクト

## action cable で実装する

前提：migration とかを終えて localhost:3000 で rails が開く。

1. config/routes.rb に付け足して有効化する

```
 mount ActionCable.server => '/cable'
```

2. config/cable.yml

```
development:
  adapter: async

test:
  adapter: test

production:
  adapter: redis
  url: <%= ENV.fetch("REDIS_URL") { "redis://localhost:6379/1" } %>
  channel_prefix: chat_app_production
```

開発用には async を指定。
redis 使わなくてもそれっぽくできるから開発環境ではありがたい。認証不要なので導入の手間がない。しかし制限があるので注意。

3. `rails g channel chat_room `して必要なファイルをたくさん用意してもらう。

```
app/channels/application_cable/channel.rb
app/channels/application_cable/connection.rb
app/channels/chat_room_channel.rb
app/javascript/channels/consumer.js
app/javascript/channels/chat_room_channel.js
app/javascript/channels/index.js
```

4. importmap.rb に色々と追加されていることを確認する

```
pin "@rails/actioncable", to: "actioncable.esm.js"
pin "controllers", to: "controllers/index.js"
pin "channels", to: "channels/index.js"
```

5. app/channels/chat_room_channel.rb を実装

- subscribe...web socket 確立
- unsbscribe...web socket 切断
- speak(カスタムメソッド)...クライアントからメッセージ受信して保存 → ブロードキャスト

6. app/javascript/channels/chat_room_channel.js を実装

- consumer.subscriptions.create()でコネクション設立

## まとめる

**サーバーサイド**
| ファイル | 役割 | 主な処理 |
| --- | --- | --- |
| connection.rb | WebSocket 接続管理 | 認証、接続確立 |
| chat_room_channel.rb | チャネル処理 | サブスクライブ、メッセージ配信 |

**クライアントサイド**
| ファイル | 役割 | 主な処理 |
| --- | --- | --- |
| consumer.js | WebSocket 接続作成| ActionCable との接続確立 |
|chat_room_channel.js | チャネル操作 | メッセージ送受信、DOM 操作 |
| index.js | チャネル読み込み | 各チャネルファイルの import |

![image2](demo/actioncable2.png)
