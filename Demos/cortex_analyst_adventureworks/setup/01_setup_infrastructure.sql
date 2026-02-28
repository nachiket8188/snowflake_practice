/*
================================================================================
 AdventureWorks Cortex Analyst - Infrastructure Setup
================================================================================
 This script sets up the necessary Snowflake objects for the Cortex Analyst demo:
 1. Creates an internal stage for the semantic model
 2. Grants necessary permissions
 
 Prerequisites:
 - ADVENTUREWORKS database with populated tables
 - ACCOUNTADMIN or equivalent role
================================================================================
*/

-- Use appropriate context
USE ROLE ACCOUNTADMIN;
USE DATABASE ADVENTUREWORKS;
USE SCHEMA PUBLIC;

-- ============================================================================
-- STEP 1: Create Internal Stage for Semantic Model
-- ============================================================================
CREATE STAGE IF NOT EXISTS CORTEX_ANALYST_STAGE
    DIRECTORY = (ENABLE = TRUE)
    COMMENT = 'Stage for Cortex Analyst semantic model files';

-- Verify stage was created
SHOW STAGES LIKE 'CORTEX_ANALYST_STAGE';

-- ============================================================================
-- STEP 2: Upload Semantic Model (run from Snowflake CLI or Snowsight)
-- ============================================================================
/*
 Option A: Using Snowflake CLI (recommended)
 -------------------------------------------
 snow stage copy semantic_models/adventureworks_sales.yaml \
   @ADVENTUREWORKS.PUBLIC.CORTEX_ANALYST_STAGE/
 
 Option B: Using Snowsight UI
 ----------------------------
 1. Navigate to Data > Databases > ADVENTUREWORKS > PUBLIC > Stages
 2. Click on CORTEX_ANALYST_STAGE
 3. Click "+ Files" button
 4. Upload adventureworks_sales.yaml
 
 Option C: Using PUT command (if running locally)
 ------------------------------------------------
 PUT file://./semantic_models/adventureworks_sales.yaml 
   @ADVENTUREWORKS.PUBLIC.CORTEX_ANALYST_STAGE
   AUTO_COMPRESS = FALSE
   OVERWRITE = TRUE;
*/

-- ============================================================================
-- STEP 3: Verify Upload
-- ============================================================================
LIST @CORTEX_ANALYST_STAGE;

-- ============================================================================
-- STEP 4: Grant Permissions (for multi-user access)
-- ============================================================================

-- Create a role for Cortex Analyst users (optional)
CREATE ROLE IF NOT EXISTS CORTEX_ANALYST_USER;

-- Grant database access
GRANT USAGE ON DATABASE ADVENTUREWORKS TO ROLE CORTEX_ANALYST_USER;
GRANT USAGE ON SCHEMA ADVENTUREWORKS.PUBLIC TO ROLE CORTEX_ANALYST_USER;
GRANT USAGE ON SCHEMA ADVENTUREWORKS.SALES TO ROLE CORTEX_ANALYST_USER;
GRANT USAGE ON SCHEMA ADVENTUREWORKS.PRODUCTION TO ROLE CORTEX_ANALYST_USER;
GRANT USAGE ON SCHEMA ADVENTUREWORKS.PERSON TO ROLE CORTEX_ANALYST_USER;

-- Grant table read access
GRANT SELECT ON ALL TABLES IN SCHEMA ADVENTUREWORKS.SALES TO ROLE CORTEX_ANALYST_USER;
GRANT SELECT ON ALL TABLES IN SCHEMA ADVENTUREWORKS.PRODUCTION TO ROLE CORTEX_ANALYST_USER;
GRANT SELECT ON ALL TABLES IN SCHEMA ADVENTUREWORKS.PERSON TO ROLE CORTEX_ANALYST_USER;

-- Grant stage read access for semantic model
GRANT READ ON STAGE ADVENTUREWORKS.PUBLIC.CORTEX_ANALYST_STAGE TO ROLE CORTEX_ANALYST_USER;

-- Grant warehouse usage (adjust warehouse name as needed)
GRANT USAGE ON WAREHOUSE SNOWFLAKE_LEARNING_WH TO ROLE CORTEX_ANALYST_USER;

-- Grant the role to users who need access
-- GRANT ROLE CORTEX_ANALYST_USER TO USER <username>;

-- ============================================================================
-- STEP 5: Test the Semantic Model (via REST API)
-- ============================================================================
/*
 The semantic model can be accessed via:
 
 Semantic Model Path: @ADVENTUREWORKS.PUBLIC.CORTEX_ANALYST_STAGE/adventureworks_sales.yaml
 
 REST API Endpoint: https://<account>.snowflakecomputing.com/api/v2/cortex/analyst/message
 
 Request Body Example:
 {
   "messages": [
     {"role": "user", "content": [{"type": "text", "text": "What is the total revenue?"}]}
   ],
   "semantic_model_file": "@ADVENTUREWORKS.PUBLIC.CORTEX_ANALYST_STAGE/adventureworks_sales.yaml"
 }
*/

-- ============================================================================
-- Cleanup Commands (if needed)
-- ============================================================================
/*
 -- Remove semantic model file
 REMOVE @CORTEX_ANALYST_STAGE/adventureworks_sales.yaml;
 
 -- Drop stage
 DROP STAGE IF EXISTS CORTEX_ANALYST_STAGE;
 
 -- Drop role
 DROP ROLE IF EXISTS CORTEX_ANALYST_USER;
*/
