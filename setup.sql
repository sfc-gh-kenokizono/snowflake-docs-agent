-- ============================================
-- Snowflake Documentation Agent Setup
-- ============================================
-- Cortex Knowledge Extension を使用して
-- Snowflake公式ドキュメントを検索できる
-- AIエージェントを作成します。
-- ============================================

USE ROLE ACCOUNTADMIN;

-- ============================================
-- Step 1: 環境のセットアップ
-- ============================================

-- エージェント用データベース・スキーマの作成
-- ※ CKE（共有DB）には直接エージェントを置けないため、
--   専用のDB.Schemaを作成します
-- ※ snowflake_intelligence.agents はパブリックプレビュー時代の
--   推奨設定のため、別名で作成します
CREATE DATABASE IF NOT EXISTS SF_DOCS_AGENT_DB;
CREATE SCHEMA IF NOT EXISTS SF_DOCS_AGENT_DB.DEMO;

GRANT USAGE ON DATABASE SF_DOCS_AGENT_DB TO ROLE PUBLIC;
GRANT USAGE ON SCHEMA SF_DOCS_AGENT_DB.DEMO TO ROLE PUBLIC;
GRANT CREATE AGENT ON SCHEMA SF_DOCS_AGENT_DB.DEMO TO ROLE PUBLIC;

-- ウェアハウスの作成
CREATE WAREHOUSE IF NOT EXISTS DOCS_AGENT_WH
  WITH WAREHOUSE_SIZE = 'XSMALL'
  AUTO_SUSPEND = 60
  AUTO_RESUME = TRUE;

GRANT USAGE ON WAREHOUSE DOCS_AGENT_WH TO ROLE PUBLIC;

-- クロスリージョン設定（必要に応じて）
-- ALTER ACCOUNT SET CORTEX_ENABLED_CROSS_REGION = 'AWS_US';


-- ============================================
-- Step 2: Snowflake Intelligence オブジェクトの作成
-- ============================================
-- ※ 既存のオブジェクトがあれば再利用（上書きしない）

CREATE SNOWFLAKE INTELLIGENCE IF NOT EXISTS SNOWFLAKE_INTELLIGENCE_OBJECT_DEFAULT;
GRANT USAGE ON SNOWFLAKE INTELLIGENCE SNOWFLAKE_INTELLIGENCE_OBJECT_DEFAULT TO ROLE PUBLIC;
GRANT MODIFY ON SNOWFLAKE INTELLIGENCE SNOWFLAKE_INTELLIGENCE_OBJECT_DEFAULT TO ROLE PUBLIC;


-- ============================================
-- Step 3: Cortex Knowledge Extension の有効化
-- ============================================
-- 
-- 【Snowsightでの操作手順】
-- 1. Data Products → Marketplace にアクセス
-- 2. 検索ボックスで "Snowflake Documentation" を検索
-- 3. "Snowflake Documentation" リスティングを選択
-- 4. "Get" ボタンをクリックしてアカウントに追加
-- 
-- ※ Knowledge Extension は Snowflake が提供する
--    マネージドデータセットです。
--    追加料金なしで利用できます。
--
-- ============================================


-- ============================================
-- Step 4: エージェントの作成
-- ============================================
-- 
-- 【Snowsightでの操作手順】
-- 1. AI & ML → Agents にアクセス
-- 2. 「+ Agent」ボタンをクリック
-- 3. 以下の設定でエージェントを作成
--
--   | 設定項目 | 値 |
--   |----------|-----|
--   | 名前 | SNOWFLAKE_DOCS_AGENT |
--   | データベース | SF_DOCS_AGENT_DB |
--   | スキーマ | DEMO |
--
-- 4. ツールとして Cortex Search > Knowledge Extension から
--    "Snowflake Documentation" を追加
--
-- 詳細は agent_config.md を参照してください
--
-- ============================================


-- ============================================
-- セットアップ完了確認
-- ============================================
SELECT 'Setup completed! Next: Add Snowflake Documentation from Marketplace.' AS status;


-- ============================================
-- クリーンアップ（不要になった場合）
-- ============================================

/*

USE ROLE ACCOUNTADMIN;

-- エージェントの削除
DROP AGENT IF EXISTS SF_DOCS_AGENT_DB.DEMO.SNOWFLAKE_DOCS_AGENT;

-- ウェアハウスの削除
DROP WAREHOUSE IF EXISTS DOCS_AGENT_WH;

-- データベース・スキーマの削除
DROP DATABASE IF EXISTS SF_DOCS_AGENT_DB;

-- Snowflake Intelligence オブジェクトの削除
-- 注意: 他のエージェントが使用していないか確認してください
-- DROP SNOWFLAKE INTELLIGENCE IF EXISTS SNOWFLAKE_INTELLIGENCE_OBJECT_DEFAULT;

SELECT 'Cleanup completed!' AS status;

*/
