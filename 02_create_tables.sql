-- =============================================================================
-- ACME MARKETING DEMO: STEP 2 - CREATE RAW DATA TABLES
-- Creating the three core tables as specified in the demo spec
-- =============================================================================

USE DATABASE SNOWFLAKE_INTELLIGENCE;

-- Create google_ads_spend table in marketing_platforms schema
USE SCHEMA marketing_platforms;
CREATE OR REPLACE TABLE google_ads_spend (
    event_date DATE,
    campaign_name VARCHAR(100),
    campaign_id VARCHAR(50),
    ad_group_name VARCHAR(100),
    keyword VARCHAR(200),
    spend DECIMAL(10,2),
    clicks INTEGER,
    impressions INTEGER,
    conversions INTEGER,
    created_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

-- Create salesforce_leads table in crm schema  
USE SCHEMA crm;
CREATE OR REPLACE TABLE salesforce_leads (
    lead_id VARCHAR(20) PRIMARY KEY,
    created_date TIMESTAMP,
    lead_email VARCHAR(100),
    lead_source VARCHAR(50),
    lead_status VARCHAR(30),
    contract_value DECIMAL(12,2),
    cancellation_reason VARCHAR(200),
    sales_rep VARCHAR(50),
    region VARCHAR(30),
    product_interest VARCHAR(100),
    last_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

-- Create website_sessions table in web_analytics schema
USE SCHEMA web_analytics;
CREATE OR REPLACE TABLE website_sessions (
    session_id VARCHAR(50) PRIMARY KEY,
    session_start_time TIMESTAMP,
    session_end_time TIMESTAMP,
    user_email VARCHAR(100),
    traffic_source VARCHAR(50),
    utm_campaign VARCHAR(100),
    utm_medium VARCHAR(50),
    utm_source VARCHAR(50),
    pages_viewed INTEGER,
    time_on_site_seconds INTEGER,
    completed_quote BOOLEAN DEFAULT FALSE,
    device_type VARCHAR(20),
    browser VARCHAR(30),
    created_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

-- Verify tables were created successfully
SELECT 'Checking table creation...' as status;

USE SCHEMA marketing_platforms;
SELECT 'google_ads_spend table' as table_name, COUNT(*) as record_count FROM google_ads_spend;

USE SCHEMA crm;
SELECT 'salesforce_leads table' as table_name, COUNT(*) as record_count FROM salesforce_leads;

USE SCHEMA web_analytics;
SELECT 'website_sessions table' as table_name, COUNT(*) as record_count FROM website_sessions;

SELECT 'STEP 2 COMPLETE: Three empty tables created successfully' as status;