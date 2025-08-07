-- =============================================================================
-- ACME MARKETING DEMO: STEP 1 - CREATE DATA SCHEMAS
-- Following the spec requirements exactly
-- =============================================================================

-- Use the Snowflake Intelligence database for the demo
USE DATABASE SNOWFLAKE_INTELLIGENCE;

-- Create the four required schemas as specified in the demo spec
CREATE SCHEMA IF NOT EXISTS marketing_platforms
COMMENT = 'Schema for marketing platform data (Google Ads, Facebook Ads, etc.)';

CREATE SCHEMA IF NOT EXISTS crm
COMMENT = 'Schema for CRM data (Salesforce leads, opportunities, etc.)';

CREATE SCHEMA IF NOT EXISTS web_analytics
COMMENT = 'Schema for website analytics data (sessions, page views, etc.)';

CREATE SCHEMA IF NOT EXISTS marketing_analysis
COMMENT = 'Schema for unified marketing analysis views and models';

-- Verify schemas were created successfully
SHOW SCHEMAS LIKE '%marketing%' OR LIKE '%crm%' OR LIKE '%web_analytics%';

SELECT 'STEP 1 COMPLETE: Four schemas created successfully' as status;