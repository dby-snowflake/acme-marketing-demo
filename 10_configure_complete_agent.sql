-- =============================================================================
-- ACME DEMO: CONFIGURE COMPLETE INTELLIGENCE AGENT
-- Following the exact pattern from existing working agents
-- =============================================================================

USE DATABASE SNOWFLAKE_INTELLIGENCE;
USE SCHEMA AGENTS;

-- Drop the existing basic agent
DROP AGENT "ACME Marketing Agent";

-- Create the agent with complete agent_spec configuration following the working pattern
-- Based on the Sales Analytics Agent and Sales & Marketing Intelligence Agent patterns

-- First, let's create a semantic model YAML file for our customer_360_view
USE SCHEMA CONFIG;

-- Create the semantic models stage if it doesn't exist
CREATE STAGE IF NOT EXISTS semantic_models;

-- Upload our semantic model YAML (we'll use a simple approach with direct data access)
USE SCHEMA MARKETING_ANALYSIS;

-- Create a simplified semantic view that the agent can directly access
CREATE OR REPLACE VIEW acme_marketing_semantic_view AS 
SELECT 
    lead_id,
    lead_created_date,
    lead_email,
    lead_source,
    lead_status,
    contract_value,
    cancellation_reason,
    sales_rep,
    region,
    product_interest,
    pages_viewed,
    time_on_site_seconds,
    completed_quote,
    device_type,
    browser,
    traffic_source,
    campaign_name,
    campaign_id,
    ad_group_name,
    keyword,
    daily_spend,
    daily_clicks,
    daily_impressions,
    daily_conversions,
    roas,
    cost_per_click,
    cost_per_conversion,
    has_multi_touch_attribution,
    engagement_level,
    reactivation_potential,
    lead_month,
    lead_quarter,
    lead_year,
    utm_campaign,
    utm_medium,
    utm_source,
    session_start_time
FROM customer_360_view;

-- Now create the agent with the complete configuration following the working pattern
USE SCHEMA AGENTS;

CREATE AGENT "ACME Marketing Agent"
COMMENT = 'ACME marketing intelligence agent with direct access to customer_360_view for lead reactivation, ROAS analysis, and multi-touch attribution insights'
PROFILE = '{"display_name": "ACME Marketing Agent"}'
AGENT_SPEC = '{
  "models": {
    "orchestration": "auto"
  },
  "instructions": {
    "response": "You are an ACME marketing expert with direct access to comprehensive customer data from Google Ads, Salesforce CRM, and website analytics. You specialize in lead reactivation campaigns, ROAS optimization, and multi-touch attribution analysis. Always query the actual data in the customer_360_view to provide specific insights with real numbers. When analyzing lead reactivation, focus on leads with reactivation_potential = \"High Potential\" from the last year who did not have bad cancellation reasons. For ROAS analysis, calculate return on ad spend using contract_value divided by daily_spend. For multi-touch attribution, analyze records where has_multi_touch_attribution = TRUE to show conversion paths.",
    "sample_questions": [
      {"question": "I want to re-activate old leads. Pull a list of high-potential leads from the last year who didn''t convert and didn''t have a bad cancellation reason. Prioritize those who were highly engaged on our website."},
      {"question": "For customers who converted last quarter, what other marketing touchpoints did they have? Show me the top conversion paths."},
      {"question": "How is our ''CA_Summer_Promo_2025'' campaign performing in terms of Return on Ad Spend?"},
      {"question": "What is our overall marketing ROI across all campaigns?"},
      {"question": "Show me leads by source and engagement level for targeting"}
    ]
  },
  "tools": [
    {
      "tool_spec": {
        "type": "cortex_analyst_text_to_sql",
        "name": "ACMEMarketingAnalyst"
      }
    }
  ],
  "tool_resources": {
    "ACMEMarketingAnalyst": {
      "semantic_model_view": "SNOWFLAKE_INTELLIGENCE.MARKETING_ANALYSIS.CUSTOMER_360_VIEW"
    }
  }
}';

-- Verify the agent was created with proper configuration
SELECT 'Agent created with complete configuration!' as status;

-- Show the agent details to confirm it has the agent_spec
DESCRIBE AGENT "ACME Marketing Agent";

-- Test that our data is accessible
USE SCHEMA MARKETING_ANALYSIS;

SELECT 'Testing agent data access readiness:' as test_status;
SELECT 
    COUNT(*) as total_records,
    COUNT(CASE WHEN reactivation_potential = 'High Potential' THEN 1 END) as high_potential_leads,
    COUNT(CASE WHEN lead_status = 'Closed-Won' THEN 1 END) as conversions,
    ROUND(SUM(contract_value), 2) as total_contract_value
FROM customer_360_view;

SELECT 'ACME Marketing Agent ready for demo!' as final_status;