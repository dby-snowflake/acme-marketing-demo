-- =============================================================================
-- ACME MARKETING DEMO: STEP 3 - POPULATE TABLES WITH REALISTIC DATA
-- Creating 200 leads, 400 sessions, and daily ad spend for the last year
-- =============================================================================

USE DATABASE SNOWFLAKE_INTELLIGENCE;

-- ==============================
-- POPULATE SALESFORCE LEADS (200 leads)
-- ==============================
USE SCHEMA crm;

-- Create 200 realistic Salesforce leads with varying statuses
-- Contract values only exist for 'Closed-Won' leads as specified
INSERT INTO salesforce_leads (
    lead_id, created_date, lead_email, lead_source, lead_status, 
    contract_value, cancellation_reason, sales_rep, region, product_interest
)
SELECT 
    'SF' || LPAD(SEQ4(), 6, '0') as lead_id,
    DATEADD('day', -UNIFORM(1, 365, RANDOM()), CURRENT_DATE()) as created_date,
    'lead' || SEQ4() || '@example.com' as lead_email,
    CASE UNIFORM(1, 5, RANDOM())
        WHEN 1 THEN 'Paid Search'
        WHEN 2 THEN 'Organic Search' 
        WHEN 3 THEN 'Email Campaign'
        WHEN 4 THEN 'Social Media'
        ELSE 'Referral'
    END as lead_source,
    CASE UNIFORM(1, 6, RANDOM())
        WHEN 1 THEN 'New'
        WHEN 2 THEN 'Qualified'
        WHEN 3 THEN 'Working'
        WHEN 4 THEN 'Closed-Won'
        WHEN 5 THEN 'Closed-Lost'
        ELSE 'Nurturing'
    END as lead_status,
    -- Contract values only for Closed-Won leads
    CASE 
        WHEN UNIFORM(1, 6, RANDOM()) = 4 -- Closed-Won status
        THEN UNIFORM(15000, 45000, RANDOM()) 
        ELSE NULL 
    END as contract_value,
    CASE 
        WHEN UNIFORM(1, 6, RANDOM()) = 5 -- Closed-Lost status
        THEN CASE UNIFORM(1, 4, RANDOM())
            WHEN 1 THEN 'Price too high'
            WHEN 2 THEN 'Competitor chosen'
            WHEN 3 THEN 'Timeline mismatch'
            ELSE 'Lost contact'
        END
        ELSE NULL
    END as cancellation_reason,
    CASE UNIFORM(1, 5, RANDOM())
        WHEN 1 THEN 'Sarah Johnson'
        WHEN 2 THEN 'Mike Chen'
        WHEN 3 THEN 'Jessica Rodriguez'
        WHEN 4 THEN 'David Kim'
        ELSE 'John Smith'
    END as sales_rep,
    CASE UNIFORM(1, 4, RANDOM())
        WHEN 1 THEN 'California'
        WHEN 2 THEN 'Texas'
        WHEN 3 THEN 'Florida'
        ELSE 'New York'
    END as region,
    CASE UNIFORM(1, 3, RANDOM())
        WHEN 1 THEN 'Residential Solar'
        WHEN 2 THEN 'Solar + Battery'
        ELSE 'Commercial Solar'
    END as product_interest
FROM TABLE(GENERATOR(ROWCOUNT => 200));

-- ==============================
-- POPULATE GOOGLE ADS SPEND (Daily entries for last year)
-- ==============================
USE SCHEMA marketing_platforms;

-- Create daily Google Ads spend data for the last year
INSERT INTO google_ads_spend (
    event_date, campaign_name, campaign_id, ad_group_name, keyword,
    spend, clicks, impressions, conversions
)
SELECT 
    date_val as event_date,
    CASE UNIFORM(1, 6, RANDOM())
        WHEN 1 THEN 'CA_Summer_Promo_2025'
        WHEN 2 THEN 'Solar_Brand_Campaign'
        WHEN 3 THEN 'Battery_Storage_Push'
        WHEN 4 THEN 'Texas_Expansion'
        WHEN 5 THEN 'Holiday_Solar_Sale'
        ELSE 'Residential_Solar_Core'
    END as campaign_name,
    'CMP' || LPAD(UNIFORM(1, 50, RANDOM()), 4, '0') as campaign_id,
    CASE UNIFORM(1, 4, RANDOM())
        WHEN 1 THEN 'Solar Installation'
        WHEN 2 THEN 'Battery Backup'
        WHEN 3 THEN 'Solar Benefits'
        ELSE 'Solar Cost'
    END as ad_group_name,
    CASE UNIFORM(1, 8, RANDOM())
        WHEN 1 THEN 'solar panels'
        WHEN 2 THEN 'solar installation'
        WHEN 3 THEN 'solar battery'
        WHEN 4 THEN 'home solar'
        WHEN 5 THEN 'solar cost'
        WHEN 6 THEN 'solar company'
        WHEN 7 THEN 'residential solar'
        ELSE 'solar energy'
    END as keyword,
    UNIFORM(50, 2000, RANDOM()) as spend,
    UNIFORM(10, 200, RANDOM()) as clicks,
    UNIFORM(1000, 10000, RANDOM()) as impressions,
    UNIFORM(0, 8, RANDOM()) as conversions
FROM (
    SELECT DATEADD('day', -seq4(), CURRENT_DATE()) as date_val
    FROM TABLE(GENERATOR(ROWCOUNT => 365))
) dates;

-- ==============================
-- POPULATE WEBSITE SESSIONS (400 sessions)
-- ==============================
USE SCHEMA web_analytics;

-- Create 400 website sessions, ensuring emails match leads and timestamps are before lead creation
INSERT INTO website_sessions (
    session_id, session_start_time, session_end_time, user_email,
    traffic_source, utm_campaign, utm_medium, utm_source,
    pages_viewed, time_on_site_seconds, completed_quote, device_type, browser
)
SELECT 
    'SES' || LPAD(SEQ4(), 8, '0') as session_id,
    -- Session timestamp is before the lead creation date
    DATEADD('hour', -UNIFORM(1, 72, RANDOM()), l.created_date) as session_start_time,
    DATEADD('minute', UNIFORM(2, 45, RANDOM()), 
        DATEADD('hour', -UNIFORM(1, 72, RANDOM()), l.created_date)) as session_end_time,
    l.lead_email as user_email,
    CASE UNIFORM(1, 6, RANDOM())
        WHEN 1 THEN 'google'
        WHEN 2 THEN 'facebook'
        WHEN 3 THEN 'email'
        WHEN 4 THEN 'direct'
        WHEN 5 THEN 'bing'
        ELSE 'youtube'
    END as traffic_source,
    CASE UNIFORM(1, 5, RANDOM())
        WHEN 1 THEN 'summer_promo'
        WHEN 2 THEN 'brand_awareness'
        WHEN 3 THEN 'solar_benefits'
        WHEN 4 THEN 'battery_storage'
        ELSE 'cost_calculator'
    END as utm_campaign,
    CASE UNIFORM(1, 4, RANDOM())
        WHEN 1 THEN 'cpc'
        WHEN 2 THEN 'social'
        WHEN 3 THEN 'email'
        ELSE 'organic'
    END as utm_medium,
    CASE UNIFORM(1, 5, RANDOM())
        WHEN 1 THEN 'google'
        WHEN 2 THEN 'facebook'
        WHEN 3 THEN 'newsletter'
        WHEN 4 THEN 'search'
        ELSE 'youtube'
    END as utm_source,
    UNIFORM(1, 15, RANDOM()) as pages_viewed,
    UNIFORM(30, 1800, RANDOM()) as time_on_site_seconds,
    CASE WHEN UNIFORM(1, 4, RANDOM()) = 1 THEN TRUE ELSE FALSE END as completed_quote,
    CASE UNIFORM(1, 3, RANDOM())
        WHEN 1 THEN 'Desktop'
        WHEN 2 THEN 'Mobile'
        ELSE 'Tablet'
    END as device_type,
    CASE UNIFORM(1, 4, RANDOM())
        WHEN 1 THEN 'Chrome'
        WHEN 2 THEN 'Safari'
        WHEN 3 THEN 'Firefox'
        ELSE 'Edge'
    END as browser
FROM (
    SELECT lead_email, created_date
    FROM crm.salesforce_leads 
    ORDER BY RANDOM()
    LIMIT 400
) l;

-- ==============================
-- VERIFY DATA POPULATION
-- ==============================
SELECT 'Verifying data population...' as status;

USE SCHEMA crm;
SELECT 'salesforce_leads' as table_name, COUNT(*) as record_count FROM salesforce_leads;

USE SCHEMA marketing_platforms;
SELECT 'google_ads_spend' as table_name, COUNT(*) as record_count FROM google_ads_spend;

USE SCHEMA web_analytics;
SELECT 'website_sessions' as table_name, COUNT(*) as record_count FROM website_sessions;

-- Show sample data from each table
SELECT 'Sample Salesforce Leads:' as info;
USE SCHEMA crm;
SELECT lead_id, created_date, lead_email, lead_source, lead_status, contract_value 
FROM salesforce_leads 
LIMIT 5;

SELECT 'Sample Google Ads Spend:' as info;
USE SCHEMA marketing_platforms;
SELECT event_date, campaign_name, spend, clicks, conversions 
FROM google_ads_spend 
LIMIT 5;

SELECT 'Sample Website Sessions:' as info;
USE SCHEMA web_analytics;
SELECT session_id, session_start_time, user_email, traffic_source, pages_viewed 
FROM website_sessions 
LIMIT 5;

SELECT 'STEP 3 COMPLETE: All tables populated with realistic data' as status;