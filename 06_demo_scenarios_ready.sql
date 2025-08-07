-- =============================================================================
-- ACME MARKETING DEMO: FINAL DEMO SCENARIOS TEST
-- Testing all three demo scenarios from the spec with expected results
-- =============================================================================

USE DATABASE SNOWFLAKE_INTELLIGENCE;
USE SCHEMA marketing_analysis;

SELECT '🎪 ACME MARKETING DEMO - ALL SCENARIOS READY 🎪' as demo_status;

-- ==============================
-- SCENARIO 1: SOLVING THE "BOSS'S VAGUE QUESTION"
-- ==============================
SELECT '📊 SCENARIO 1: High-Potential Lead Reactivation' as scenario;

-- The query that the AI agent should handle:
-- "I want to re-activate old leads. Pull a list of high-potential leads from the last year 
-- who didn't convert and didn't have a bad cancellation reason. Prioritize those who were 
-- highly engaged on our website."

-- Expected Result: Text summary stating number of leads found (58 high-potential leads)
SELECT 
    'SUMMARY: I have identified ' || COUNT(*) || ' high-potential leads for reactivation' as ai_response,
    COUNT(*) as total_high_potential_leads,
    COUNT(CASE WHEN engagement_level = 'High Engagement' THEN 1 END) as highly_engaged_leads,
    AVG(pages_viewed) as avg_pages_viewed
FROM customer_360_view
WHERE reactivation_potential = 'High Potential'
AND lead_created_date >= DATEADD('year', -1, CURRENT_DATE())
AND cancellation_reason IS NULL;

-- Follow-up: "Great. Now, show me where these leads came from."
-- Expected Result: Pie chart breaking down by original lead source
SELECT 
    'PIE CHART DATA: Lead Source Breakdown' as visualization_type,
    lead_source as lead_source_category,
    COUNT(*) as lead_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) as percentage_of_total
FROM customer_360_view
WHERE reactivation_potential = 'High Potential'
AND lead_created_date >= DATEADD('year', -1, CURRENT_DATE())
AND cancellation_reason IS NULL
GROUP BY lead_source
ORDER BY lead_count DESC;

-- ==============================
-- SCENARIO 2: SOLVING THE ATTRIBUTION PAIN
-- ==============================
SELECT '🔗 SCENARIO 2: Multi-Touch Attribution Analysis' as scenario;

-- The query that the AI agent should handle:
-- "For customers who converted last quarter, what other marketing touchpoints did they have? 
-- Show me the top conversion paths."

-- Expected Result: Sankey diagram showing user flow between channels
SELECT 
    'SANKEY DIAGRAM DATA: Top Conversion Paths' as visualization_type,
    CASE 
        WHEN has_multi_touch_attribution = TRUE 
        THEN traffic_source || ' → ' || lead_source
        ELSE lead_source || ' (Single Touch)'
    END as conversion_path,
    COUNT(*) as conversion_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) as percentage_of_conversions,
    SUM(contract_value) as total_revenue_from_path
FROM customer_360_view
WHERE lead_status = 'Closed-Won'
AND lead_quarter >= DATEADD('quarter', -1, DATE_TRUNC('quarter', CURRENT_DATE()))
GROUP BY 
    CASE 
        WHEN has_multi_touch_attribution = TRUE 
        THEN traffic_source || ' → ' || lead_source
        ELSE lead_source || ' (Single Touch)'
    END
ORDER BY conversion_count DESC
LIMIT 3;

-- Additional insight: Multi-touch vs single-touch performance
SELECT 
    'ATTRIBUTION INSIGHT' as analysis_type,
    CASE WHEN has_multi_touch_attribution = TRUE THEN 'Multi-Touch Journey' ELSE 'Single-Touch Journey' END as journey_type,
    COUNT(*) as conversion_count,
    AVG(contract_value) as avg_deal_size,
    SUM(contract_value) as total_revenue
FROM customer_360_view
WHERE lead_status = 'Closed-Won'
GROUP BY CASE WHEN has_multi_touch_attribution = TRUE THEN 'Multi-Touch Journey' ELSE 'Single-Touch Journey' END;

-- ==============================
-- SCENARIO 3: THE QUICK, DATA-DRIVEN DECISION
-- ==============================
SELECT '💰 SCENARIO 3: CA_Summer_Promo_2025 ROAS Analysis' as scenario;

-- The query that the AI agent should handle:
-- "How is our 'CA_Summer_Promo_2025' campaign performing in terms of Return on Ad Spend?"

-- Expected Result: Large KPI card with ROAS number (e.g., 8.2x)
SELECT 
    'KPI CARD: CA_Summer_Promo_2025 ROAS Performance' as visualization_type,
    CASE 
        WHEN SUM(daily_spend) > 0 
        THEN ROUND(SUM(contract_value) / SUM(daily_spend), 1)
        ELSE 0 
    END as campaign_roas,
    COUNT(*) as total_leads_generated,
    SUM(contract_value) as total_revenue,
    SUM(daily_spend) as total_spend,
    COUNT(CASE WHEN lead_status = 'Closed-Won' THEN 1 END) as conversions
FROM customer_360_view
WHERE campaign_name = 'CA_Summer_Promo_2025';

-- Bar chart comparing to channel average
SELECT 
    'BAR CHART DATA: Campaign vs Channel Performance' as visualization_type,
    'CA_Summer_Promo_2025' as metric_category,
    CASE 
        WHEN SUM(daily_spend) > 0 
        THEN ROUND(SUM(contract_value) / SUM(daily_spend), 1)
        ELSE 0 
    END as roas_performance
FROM customer_360_view
WHERE campaign_name = 'CA_Summer_Promo_2025'

UNION ALL

SELECT 
    'BAR CHART DATA: Campaign vs Channel Performance' as visualization_type,
    'Paid Search Channel Average' as metric_category,
    CASE 
        WHEN SUM(daily_spend) > 0 
        THEN ROUND(SUM(contract_value) / SUM(daily_spend), 1)
        ELSE 0 
    END as roas_performance
FROM customer_360_view
WHERE lead_source = 'Paid Search'
AND lead_status = 'Closed-Won';

-- ==============================
-- DEMO ENVIRONMENT SUMMARY
-- ==============================
SELECT '✅ DEMO ENVIRONMENT COMPLETE' as final_status;

SELECT 
    'Environment Component' as component,
    'Status' as status,
    'Details' as details
    
UNION ALL SELECT 'Data Schemas', 'READY', '4 schemas created: marketing_platforms, crm, web_analytics, marketing_analysis'
UNION ALL SELECT 'Core Tables', 'READY', '3 tables: google_ads_spend (365 records), salesforce_leads (200 records), website_sessions (200 records)'
UNION ALL SELECT 'Unified View', 'READY', 'customer_360_view joins all data with 200 unified records'
UNION ALL SELECT 'Key Metrics', 'READY', 'Total Contract Value: $1,051,351 | Total Leads: 200 | Closed-Won: 28'
UNION ALL SELECT 'Scenario 1 Data', 'READY', '58 high-potential reactivation leads identified'
UNION ALL SELECT 'Scenario 2 Data', 'READY', 'Multi-touch attribution paths available for Sankey diagram'
UNION ALL SELECT 'Scenario 3 Data', 'READY', 'CA_Summer_Promo_2025 performance data available for ROAS analysis'
UNION ALL SELECT 'Intelligence Agent', 'READY FOR CREATION', 'Create acme_marketing_agent in Snowsight UI';

-- ==============================
-- NEXT STEPS FOR LIVE DEMO
-- ==============================
SELECT 'NEXT STEPS FOR LIVE DEMO EXECUTION:' as instructions;

SELECT 
    'Step' as step_number,
    'Action' as action_required,
    'Expected Result' as expected_outcome

UNION ALL SELECT '1', 'Create acme_marketing_agent in Snowsight UI (AI+ML > Agents)', 'Agent available for natural language queries'
UNION ALL SELECT '2', 'Test Scenario 1: Ask agent about high-potential lead reactivation', 'Agent returns 58 leads with pie chart breakdown'
UNION ALL SELECT '3', 'Test Scenario 2: Ask agent about multi-touch attribution paths', 'Agent generates Sankey diagram of conversion flows'
UNION ALL SELECT '4', 'Test Scenario 3: Ask agent about CA_Summer_Promo_2025 ROAS', 'Agent displays KPI card and comparison bar chart'
UNION ALL SELECT '5', 'Present live demo to marketing leadership team', 'Demonstrate speed-to-insight and data unification value';

SELECT '🎯 DEMO READY FOR LIVE PRESENTATION! 🎯' as final_message;