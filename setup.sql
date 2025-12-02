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

-- データベースの作成
CREATE DATABASE IF NOT EXISTS snowflake_intelligence;
GRANT USAGE ON DATABASE snowflake_intelligence TO ROLE PUBLIC;

-- スキーマの作成
CREATE SCHEMA IF NOT EXISTS snowflake_intelligence.agents;
GRANT USAGE ON SCHEMA snowflake_intelligence.agents TO ROLE PUBLIC;

-- エージェント作成権限の付与
GRANT CREATE AGENT ON SCHEMA snowflake_intelligence.agents TO ROLE PUBLIC;

-- ウェアハウスの作成（オプション）
CREATE WAREHOUSE IF NOT EXISTS docs_agent_wh
  WITH WAREHOUSE_SIZE = 'XSMALL'
  AUTO_SUSPEND = 60
  AUTO_RESUME = TRUE;

GRANT USAGE ON WAREHOUSE docs_agent_wh TO ROLE PUBLIC;

-- クロスリージョン設定（必要に応じて）
-- ALTER ACCOUNT SET CORTEX_ENABLED_CROSS_REGION = 'AWS_US';


-- ============================================
-- Step 2: Cortex Knowledge Extension の有効化
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
-- Step 3: エージェントの作成
-- ============================================
-- 
-- 【Snowsightでの操作手順】
-- 1. AI & ML → Agents にアクセス
-- 2. 「+ Agent」ボタンをクリック
-- 3. 以下の設定でエージェントを作成
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
DROP AGENT IF EXISTS SNOWFLAKE_INTELLIGENCE.AGENTS.SNOWFLAKE_DOCS_AGENT;

-- ウェアハウスの削除
DROP WAREHOUSE IF EXISTS DOCS_AGENT_WH;

-- データベース・スキーマの削除
-- 注意: 他のエージェントが使用していないか確認してください
-- DROP DATABASE IF EXISTS SNOWFLAKE_INTELLIGENCE;

SELECT 'Cleanup completed!' AS status;

*/

