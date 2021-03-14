# ECS Python Sample

Docker ECS 統合の Python サンプルコード  
Docker ECS 統合機能を使うことでローカルでの検証と ECS(Fargate)上での実行をシームレスにつなぐことが可能

## 必要条件

- docker, aws cli, make が利用可能であること
- aws configure の profile に default で設定されていること
- Docker Desktop のバージョン及び AWS の権限が十分であること([参考](https://matsuand.github.io/docs.docker.jp.onthefly/cloud/ecs-integration/#prerequisites))

※稼働確認は以下の通り

- macOS Catalina: v10.15.7
- Docker Desktop for Mac: v3.1.0
- Docker Engine: v20.10.2
- AWS CLI: v2.1.5
- GNU Make: v3.81

## 使い方

※**ローカル実行の場合は S3 の利用料金、ECS 実行の場合は S3, ECR, ECS の利用料金がかかります**

以下の API を提供する Python(FastAPI)コンテナを作成する

| パス | 内容                              |
| ---- | --------------------------------- |
| /    | Hello World を返す                |
| /s3  | s3 上の json ファイルの内容を返す |

### 事前準備(ローカル・ECS 共通)

- AWS 認証情報を.env ファイルへ出力
- ECS コンテキストの作成
- ECR 作成
- サンプルファイルを S3 へアップロード
  - サンプルファイルの作成には[World Time API](http://worldtimeapi.org/)を利用しています

```bash
./script.sh setup
```

### ローカル実行

```bash
make up
curl localhost:8000
curl localhost:8000/s3
```

### ECS 実行

```bash
make up
# docker compose psまたはAWSコンソールからエンドポイントを確認
curl [endpoint]
curl [endpoint]/s3
```

### 後始末(ローカル・ECS 共通)

```bash
./script.sh teardown
```
