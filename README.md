# Snowflake Documentation Agent - JA

## 概要

Cortex Knowledge Extension を使用して、Snowflake 公式ドキュメントを検索・参照できる AI エージェントを構築するプロジェクトです。

**Snowflake Intelligence** と **Cortex Agent** を活用し、日本語で Snowflake のドキュメントに質問できる環境を構築します。

## 特徴

- 🔍 **Snowflake Documentation 検索**: Marketplace の Knowledge Extension を活用
- 🇯🇵 **日本語対応**: 日本語での質問・回答に対応
- 📚 **公式ドキュメント準拠**: 回答は公式ドキュメントに基づく
- 🛡️ **エンタープライズ品質**: 適切なガイドラインとフォーマット

## 前提条件

- Snowflake アカウント（ACCOUNTADMIN 権限が必要）
- Cortex LLM へのアクセス
- 対応リージョン（AWS US 推奨）

## ファイル構成

```
.
├── README.md              # このファイル
├── setup.sql              # 環境セットアップ SQL
├── agent_config.md        # エージェント設定ガイド
└── LICENSE                # ライセンス
```

## セットアップ手順

### Step 1: 環境のセットアップ

`setup.sql` を Snowsight で実行し、必要なリソースを作成します：

- **データベース**: `SHARED_CORTEX_AGENTS_DB`
- **スキーマ**: `AGENTS`
- **ウェアハウス**: `DOCS_AGENT_WH`
- **Snowflake Intelligence オブジェクト**: `SNOWFLAKE_INTELLIGENCE_OBJECT_DEFAULT`

```sql
-- Snowsight の SQL Worksheet で setup.sql を実行
USE ROLE ACCOUNTADMIN;

-- 共有オブジェクトを使うエージェント用の共通DB
CREATE DATABASE IF NOT EXISTS SHARED_CORTEX_AGENTS_DB;
CREATE SCHEMA IF NOT EXISTS SHARED_CORTEX_AGENTS_DB.AGENTS;

-- Snowflake Intelligence オブジェクト（既存があれば再利用）
CREATE SNOWFLAKE INTELLIGENCE IF NOT EXISTS SNOWFLAKE_INTELLIGENCE_OBJECT_DEFAULT;
```

### Step 2: Snowflake Documentation の取得

1. Snowsight で **Data Products** → **Marketplace** にアクセス
2. 検索ボックスで `Snowflake Documentation` を検索
3. **Snowflake Documentation** リスティングを選択
4. **Get** ボタンをクリック

![Marketplace](https://docs.snowflake.com/en/_images/marketplace-listing.png)

### Step 3: エージェントの作成

`agent_config.md` の手順に従って、Snowsight でエージェントを作成します。

1. **AI & ML** → **Agents** にアクセス
2. **+ Agent** をクリック
3. Knowledge Extension として **Snowflake Documentation** を追加
4. System Prompt と Response Instructions を設定

詳細は [agent_config.md](./agent_config.md) を参照してください。

## サンプル質問

エージェントに以下のような質問を試してみてください：

```
Snowflakeのウェアハウスのサイズ変更方法を教えてください
```

```
Cortex LLM関数の一覧と使い方を教えてください
```

```
Time Travelとは何ですか？設定方法を教えてください
```

```
ストリームとタスクを使ったCDCパイプラインの構築方法を教えてください
```

```
Snowparkとは何ですか？PythonでUDFを作成する方法を教えてください
```

## アーキテクチャ

```
┌─────────────────────────────────────────────────────────────┐
│                    Snowflake Intelligence                    │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────────────────────────────────────────────────┐   │
│  │                    Cortex Agent                       │   │
│  │  ┌────────────────────────────────────────────────┐  │   │
│  │  │              System Prompt                      │  │   │
│  │  │  - ペルソナ設定                                  │  │   │
│  │  │  - トーン＆マナー                                │  │   │
│  │  └────────────────────────────────────────────────┘  │   │
│  │  ┌────────────────────────────────────────────────┐  │   │
│  │  │           Response Instructions                 │  │   │
│  │  │  - 回答生成ルール                               │  │   │
│  │  │  - フォーマット指定                             │  │   │
│  │  │  - 禁止事項                                     │  │   │
│  │  └────────────────────────────────────────────────┘  │   │
│  │  ┌────────────────────────────────────────────────┐  │   │
│  │  │               Tools                             │  │   │
│  │  │  ┌──────────────────────────────────────────┐  │  │   │
│  │  │  │  Cortex Search (Knowledge Extension)     │  │  │   │
│  │  │  │  └─ Snowflake Documentation              │  │  │   │
│  │  │  └──────────────────────────────────────────┘  │  │   │
│  │  └────────────────────────────────────────────────┘  │   │
│  └──────────────────────────────────────────────────────┘   │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

## カスタマイズ

### ペルソナの変更

`agent_config.md` の System Prompt を編集して、エージェントのキャラクターを変更できます：

- **テクニカルサポート向け**: より技術的で詳細な回答
- **初心者向け**: より丁寧で基礎的な説明
- **開発者向け**: コード例を多く含む回答

### 他の Knowledge Extension の追加

Marketplace から他の Knowledge Extension を追加することで、エージェントの知識を拡張できます。

## 参考リンク

- [Snowflake Intelligence ドキュメント](https://docs.snowflake.com/ja/user-guide/snowflake-cortex/snowflake-intelligence)
- [Cortex Agent ドキュメント](https://docs.snowflake.com/ja/user-guide/snowflake-cortex/cortex-agent)
- [Cortex Search ドキュメント](https://docs.snowflake.com/ja/user-guide/snowflake-cortex/cortex-search/cortex-search-overview)
- [Snowflake Marketplace](https://app.snowflake.com/marketplace)

## ライセンス

Apache License 2.0

