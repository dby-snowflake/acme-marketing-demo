-- =============================================================================
-- ACME MARKETING DEMO: STEP 4 - CREATE UNIFIED VIEW
-- Creating customer_360_view that joins all three tables together
-- =============================================================================

USE DATABASE SNOWFLAKE_INTELLIGENCE;
USE SCHEMA marketing_analysis;

-- Create the unified customer_360_view that links web sessions and ad spend to leads
CREATE OR REPLACE VIEW customer_360_view AS
SELECT 
    -- Lead information from Salesforce
    l.lead_id,
    l.created_date as lead_created_date,
    l.lead_email,
    l.lead_source,
    l.lead_status,
    l.contract_value,
    l.cancellation_reason,
    l.sales_rep,
    l.region,
    l.product_interest,
    
    -- Website session information (most recent session before lead creation)
    ws.session_id,
    ws.session_start_time,
    ws.traffic_source,
    ws.utm_campaign,
    ws.utm_medium,
    ws.utm_source,
    ws.pages_viewed,
    ws.time_on_site_seconds,
    ws.completed_quote,
    ws.device_type,
    ws.browser,
    
    -- Google Ads spend information (matching campaign and date)
    ga.campaign_name,
    ga.campaign_id,
    ga.ad_group_name,
    ga.keyword,
    ga.spend as daily_spend,
    ga.clicks as daily_clicks,
    ga.impressions as daily_impressions,
    ga.conversions as daily_conversions,
    
    -- Calculated metrics for analysis
    CASE 
        WHEN l.contract_value IS NOT NULL AND ga.spend IS NOT NULL AND ga.spend > 0
        THEN ROUND(l.contract_value / ga.spend, 2)
        ELSE NULL
    END as roas,
    
    CASE 
        WHEN ga.clicks IS NOT NULL AND ga.spend IS NOT NULL AND ga.clicks > 0
        THEN ROUND(ga.spend / ga.clicks, 2)
        ELSE NULL
    END as cost_per_click,
    
    CASE 
        WHEN ga.conversions IS NOT NULL AND ga.spend IS NOT NULL AND ga.conversions > 0
        THEN ROUND(ga.spend / ga.conversions, 2)
        ELSE NULL
    END as cost_per_conversion,
    
    -- Attribution and engagement flags
    CASE 
        WHEN ws.traffic_source IS NOT NULL AND ws.traffic_source != l.lead_source 
        THEN TRUE 
        ELSE FALSE 
    END as has_multi_touch_attribution,
    
    CASE 
        WHEN ws.pages_viewed >= 5 THEN 'High Engagement'
        WHEN ws.pages_viewed >= 2 THEN 'Medium Engagement'
        ELSE 'Low Engagement'
    END as engagement_level,
    
    -- Lead scoring for reactivation (high-potential leads criteria from spec)
    CASE 
        WHEN l.lead_status IN ('Qualified', 'Working', 'Nurturing')
        AND l.cancellation_reason IS NULL
        AND ws.pages_viewed >= 5
        AND l.created_date >= DATEADD('year', -1, CURRENT_DATE())
        THEN 'High Potential'
        
        WHEN l.lead_status IN ('Qualified', 'Working', 'Nurturing')
        AND l.cancellation_reason IS NULL
        AND l.created_date >= DATEADD('year', -1, CURRENT_DATE())
        THEN 'Medium Potential'
        
        ELSE 'Low Potential'
    END as reactivation_potential,
    
    -- Time-based groupings for analysis
    DATE_TRUNC('month', l.created_date) as lead_month,
    DATE_TRUNC('quarter', l.created_date) as lead_quarter,
    EXTRACT('year', l.created_date) as lead_year

FROM crm.salesforce_leads l

-- Left join with website sessions (most recent session before lead creation)
LEFT JOIN (
    SELECT 
        ws.*,
        ROW_NUMBER() OVER (PARTITION BY ws.user_email ORDER BY ws.session_start_time DESC) as session_rank
    FROM web_analytics.website_sessions ws
) ws ON l.lead_email = ws.user_email 
    AND ws.session_start_time <= l.created_date
    AND ws.session_rank = 1  -- Most recent session before lead creation

-- Left join with Google Ads spend (matching campaign and date)
LEFT JOIN marketing_platforms.google_ads_spend ga 
    ON ga.event_date = DATE(l.created_date)
    AND (
        -- Match by campaign name in UTM
        LOWER(ga.campaign_name) = LOWER(ws.utm_campaign)
        OR 
        -- Match by keyword relevance to lead source
        (LOWER(l.lead_source) LIKE '%search%' AND LOWER(ga.keyword) LIKE '%solar%')
        OR
        -- Default match for paid search leads
        (LOWER(l.lead_source) = 'paid search' AND ga.campaign_name IS NOT NULL)
    );

-- ==============================
-- VERIFY UNIFIED VIEW CREATION
-- ==============================

-- Test the view with sample data
SELECT 'Testing customer_360_view...' as status;

SELECT COUNT(*) as total_records FROM customer_360_view;

-- Show sample unified data
SELECT 
    lead_id,
    lead_created_date,
    lead_email,
    lead_source,
    lead_status,
    contract_value,
    traffic_source,
    pages_viewed,
    campaign_name,
    daily_spend,
    roas,
    engagement_level,
    reactivation_potential
FROM customer_360_view
LIMIT 10;

-- Show key metrics for demo scenarios
SELECT 'Demo Scenario Metrics:' as info;

-- Count of high-potential reactivation leads (for demo scenario 1)
SELECT 
    'High-Potential Reactivation Leads' as metric,
    COUNT(*) as count
FROM customer_360_view
WHERE reactivation_potential = 'High Potential';

-- Multi-touch attribution analysis (for demo scenario 2)  
SELECT 
    'Multi-Touch Attribution Paths' as metric,
    COUNT(*) as leads_with_multi_touch
FROM customer_360_view
WHERE has_multi_touch_attribution = TRUE
AND lead_status = 'Closed-Won';

-- ROAS data for CA_Summer_Promo_2025 (for demo scenario 3)
SELECT 
    'CA_Summer_Promo_2025 Performance' as metric,
    COUNT(*) as leads_from_campaign,
    AVG(roas) as avg_roas
FROM customer_360_view
WHERE campaign_name = 'CA_Summer_Promo_2025'
AND lead_status = 'Closed-Won';

SELECT 'STEP 4 COMPLETE: customer_360_view created successfully' as status;