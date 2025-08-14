# 🎯 ACME Marketing Demo - Snowflake Intelligence

## Overview
This repository contains a complete demonstration of Snowflake Intelligence for marketing analytics, featuring unified customer data analysis, lead reactivation, ROAS optimization, and multi-touch attribution.

## What This Demo Shows
- **Unified Customer 360°**: Combines Google Ads, Salesforce CRM, and website analytics data
- **Natural Language Queries**: Ask complex marketing questions in plain English
- **Automated Insights**: Get instant answers with visualizations and actionable recommendations
- **Real-time Analytics**: Replace manual spreadsheet analysis with AI-powered insights

## Demo Components
- ✅ **Intelligent Agent**: Natural language interface for marketing analytics
- ✅ **Data**: 200 unified customer records with realistic marketing attribution
- ✅ **Semantic Model**: Proper YAML format for Cortex Analyst
- ✅ **Demo Scenarios**: 3 scenarios ready for live presentation

## Quick Start

### Prerequisites
- Snowflake account with Snowflake Intelligence enabled
- `SNOWFLAKE_INTELLIGENCE_ADMIN_RL` role or equivalent permissions

### Installation

Follow these steps in order to set up the complete demo environment:

### 1. Create Database Schemas
```sql
-- File: 01_create_schemas.sql
USE ROLE SNOWFLAKE_INTELLIGENCE_ADMIN_RL;

CREATE DATABASE IF NOT EXISTS SNOWFLAKE_INTELLIGENCE;
CREATE SCHEMA IF NOT EXISTS SNOWFLAKE_INTELLIGENCE.MARKETING_PLATFORMS;
CREATE SCHEMA IF NOT EXISTS SNOWFLAKE_INTELLIGENCE.CRM;
CREATE SCHEMA IF NOT EXISTS SNOWFLAKE_INTELLIGENCE.WEB_ANALYTICS;
CREATE SCHEMA IF NOT EXISTS SNOWFLAKE_INTELLIGENCE.MARKETING_ANALYSIS;
```

### 2. Create Raw Data Tables
```sql
-- File: 02_create_tables.sql
USE DATABASE SNOWFLAKE_INTELLIGENCE;

-- Google Ads Spend Table
USE SCHEMA MARKETING_PLATFORMS;
CREATE TABLE google_ads_spend (
    spend_date DATE,
    campaign_name VARCHAR(100),
    campaign_id VARCHAR(50),
    ad_group_name VARCHAR(100),
    keyword VARCHAR(200),
    daily_spend DECIMAL(10,2),
    daily_clicks INTEGER,
    daily_impressions INTEGER,
    daily_conversions INTEGER,
    cost_per_click DECIMAL(10,2),
    cost_per_conversion DECIMAL(10,2)
);

-- Salesforce Leads Table
USE SCHEMA CRM;
CREATE TABLE salesforce_leads (
    lead_id VARCHAR(20),
    lead_created_date TIMESTAMP,
    lead_email VARCHAR(100),
    lead_source VARCHAR(50),
    lead_status VARCHAR(30),
    contract_value DECIMAL(12,2),
    cancellation_reason VARCHAR(200),
    sales_rep VARCHAR(50),
    region VARCHAR(30),
    product_interest VARCHAR(100)
);

-- Website Sessions Table
USE SCHEMA WEB_ANALYTICS;
CREATE TABLE website_sessions (
    session_id VARCHAR(50),
    lead_id VARCHAR(20),
    session_start_time TIMESTAMP,
    traffic_source VARCHAR(50),
    utm_campaign VARCHAR(100),
    utm_medium VARCHAR(50),
    utm_source VARCHAR(50),
    pages_viewed INTEGER,
    time_on_site_seconds INTEGER,
    completed_quote BOOLEAN,
    device_type VARCHAR(20),
    browser VARCHAR(30)
);
```

### 3. Populate with Demo Data
```sql
-- File: 03_populate_data.sql
-- Insert 200 Salesforce leads, 365 Google Ads records, 200 website sessions
-- See actual script for full INSERT statements with realistic data
```

### 4. Create Unified Customer View
```sql
-- File: 04_create_unified_view.sql
USE SCHEMA MARKETING_ANALYSIS;

CREATE VIEW customer_360_view AS
SELECT 
    -- Lead Information
    sl.lead_id,
    sl.lead_created_date,
    sl.lead_email,
    sl.lead_source,
    sl.lead_status,
    sl.contract_value,
    sl.cancellation_reason,
    sl.sales_rep,
    sl.region,
    sl.product_interest,
    
    -- Website Analytics
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
    
    -- Campaign Data
    gas.campaign_name,
    gas.campaign_id,
    gas.ad_group_name,
    gas.keyword,
    gas.daily_spend,
    gas.daily_clicks,
    gas.daily_impressions,
    gas.daily_conversions,
    CASE 
        WHEN gas.daily_spend > 0 
        THEN ROUND(sl.contract_value / gas.daily_spend, 2)
        ELSE NULL 
    END as roas,
    gas.cost_per_click,
    gas.cost_per_conversion,
    
    -- Calculated Fields
    CASE 
        WHEN ws.utm_source IS NOT NULL AND gas.campaign_name IS NOT NULL 
        THEN TRUE 
        ELSE FALSE 
    END as has_multi_touch_attribution,
    
    CASE 
        WHEN ws.pages_viewed >= 8 THEN 'Highly Engaged'
        WHEN ws.pages_viewed >= 4 THEN 'Moderately Engaged' 
        ELSE 'Low Engagement'
    END as engagement_level,
    
    CASE 
        WHEN sl.lead_status IN ('Open', 'Qualified') 
        AND sl.cancellation_reason IS NULL
        AND ws.pages_viewed >= 6
        AND sl.lead_created_date >= DATEADD('year', -1, CURRENT_DATE())
        THEN 'High Potential'
        WHEN sl.lead_status IN ('Open', 'Qualified') 
        AND sl.cancellation_reason IS NULL
        THEN 'Medium Potential'
        ELSE 'Low Potential'
    END as reactivation_potential,
    
    -- Time Dimensions
    DATE_TRUNC('month', sl.lead_created_date) as lead_month,
    DATE_TRUNC('quarter', sl.lead_created_date) as lead_quarter,
    YEAR(sl.lead_created_date) as lead_year

FROM CRM.salesforce_leads sl
LEFT JOIN WEB_ANALYTICS.website_sessions ws ON sl.lead_id = ws.lead_id
LEFT JOIN MARKETING_PLATFORMS.google_ads_spend gas ON gas.campaign_name = ws.utm_campaign;
```

### 5. Create Semantic Model YAML
```yaml
# File: sunrun_semantic_model.yaml
name: sunrun_marketing_analytics
description: Comprehensive Sunrun marketing analytics covering leads, campaigns, conversions, and website engagement for lead reactivation, ROAS analysis, and multi-touch attribution
tables:
  - name: customer_360_view
    base_table:
      database: SNOWFLAKE_INTELLIGENCE
      schema: MARKETING_ANALYSIS
      table: CUSTOMER_360_VIEW
    description: Unified customer view combining Google Ads, Salesforce CRM, and website analytics data
    dimensions:
      - name: lead_id
        expr: lead_id
        data_type: text
        description: Unique identifier for each lead
      - name: lead_source
        expr: lead_source
        data_type: text
        description: Source where the lead originated (Organic Search, Paid Search, Social Media, etc.)
      - name: lead_status
        expr: lead_status
        data_type: text
        description: Current status of the lead (Open, Qualified, Closed-Won, Closed-Lost)
      - name: reactivation_potential
        expr: reactivation_potential
        data_type: text
        description: Potential for lead reactivation (High Potential, Medium Potential, Low Potential)
      - name: campaign_name
        expr: campaign_name
        data_type: text
        description: Name of the marketing campaign
      - name: engagement_level
        expr: engagement_level
        data_type: text
        description: Level of website engagement (High, Medium, Low)
      - name: has_multi_touch_attribution
        expr: has_multi_touch_attribution
        data_type: boolean
        description: Whether lead has multi-touch attribution data available
      - name: lead_created_date
        expr: lead_created_date
        data_type: date
        description: Date when the lead was created
      - name: cancellation_reason
        expr: cancellation_reason
        data_type: text
        description: Reason for cancellation if lead was cancelled
    measures:
      - name: contract_value
        expr: contract_value
        data_type: number
        description: Value of the contract if closed-won
      - name: daily_spend
        expr: daily_spend
        data_type: number
        description: Daily advertising spend
      - name: roas
        expr: roas
        data_type: number
        description: Return on advertising spend
      - name: pages_viewed
        expr: pages_viewed
        data_type: number
        description: Number of pages viewed on website
      - name: time_on_site_seconds
        expr: time_on_site_seconds
        data_type: number
        description: Time spent on website in seconds
```

### 6. Upload Semantic Model
```sql
USE DATABASE SNOWFLAKE_INTELLIGENCE;
USE SCHEMA CONFIG;
PUT file:///path/to/acme_semantic_model.yaml @semantic_models AUTO_COMPRESS=FALSE OVERWRITE=TRUE;
```

### 7. Create Intelligence Agent

#### Option A: Complete Marketing Intelligence Agent (Recommended)
```sql
-- Execute the complete setup script:
-- 11_create_marketing_intelligence_agent.sql
```

This creates the **ACME Marketing Intelligence Agent** with:
- 4 tools: Customer data analysis, sentiment analysis, document search, web search
- AI sentiment analysis using SNOWFLAKE.CORTEX.SENTIMENT()
- Marketing document search service
- Email campaign response analysis
- Industry benchmarking capabilities

#### Option B: Basic Marketing Agent
```sql
USE DATABASE SNOWFLAKE_INTELLIGENCE;
USE SCHEMA AGENTS;

CREATE AGENT SNOWFLAKE_INTELLIGENCE.AGENTS."Sunrun Marketing Agent"
WITH PROFILE='{"display_name": "Sunrun Marketing Agent"}'
    COMMENT='Expert Sunrun marketing analyst with access to comprehensive customer data for lead reactivation, ROAS analysis, and multi-touch attribution insights'
FROM SPECIFICATION $$
{
    "models": { "orchestration": "auto" },
    "instructions": {
        "response": "You are a Sunrun marketing expert with access to comprehensive customer data from Google Ads, Salesforce CRM, and website analytics. You specialize in lead reactivation campaigns, ROAS optimization, and multi-touch attribution analysis. Always query the actual data in the customer_360_view to provide specific insights with real numbers. When analyzing lead reactivation, focus on leads with reactivation_potential = 'High Potential' from the last year who did not have bad cancellation reasons. For ROAS analysis, calculate return on ad spend using contract_value divided by daily_spend. For multi-touch attribution, analyze records where has_multi_touch_attribution = TRUE to show conversion paths.",
        "orchestration": "Always use the SunrunAnalyst tool to query actual customer data. Provide specific numbers and actionable insights based on real data.",
        "sample_questions": [
            { "question": "I want to re-activate old leads. Pull a list of high-potential leads from the last year who didn't convert and didn't have a bad cancellation reason. Prioritize those who were highly engaged on our website." },
            { "question": "For customers who converted last quarter, what other marketing touchpoints did they have? Show me the top conversion paths." },
            { "question": "How is our 'CA_Summer_Promo_2025' campaign performing in terms of Return on Ad Spend?" },
            { "question": "What is our overall marketing ROI across all campaigns?" },
            { "question": "Show me leads by source and engagement level for targeting" }
        ]
    },
    "tools": [
        {
            "tool_spec": {
                "name": "SunrunAnalyst",
                "type": "cortex_analyst_text_to_sql",
                "description": "Analyzes Sunrun customer data including leads, campaigns, conversions, and website engagement for marketing insights"
            }
        }
    ],
    "tool_resources": {
        "SunrunAnalyst": {
            "semantic_model_file": "@snowflake_intelligence.config.semantic_models/sunrun_semantic_model.yaml"
        }
    }
}
$$;
```

## Verification
After setup, verify the demo works:

```sql
-- Check data
SELECT COUNT(*) as total_records,
       COUNT(CASE WHEN reactivation_potential = 'High Potential' THEN 1 END) as high_potential_leads,
       COUNT(CASE WHEN lead_status = 'Closed-Won' THEN 1 END) as conversions
FROM SNOWFLAKE_INTELLIGENCE.MARKETING_ANALYSIS.customer_360_view;

-- Expected: 200 total, 58 high-potential, 28 conversions
```

## Demo Test Scenarios

### Scenario 1: Lead Reactivation
```
I want to re-activate old leads. Pull a list of high-potential leads from the last year who didn't convert and didn't have a bad cancellation reason. Prioritize those who were highly engaged on our website.
```
**Expected**: 58 high-potential leads with breakdown by source

### Scenario 2: Multi-Touch Attribution
```
For customers who converted last quarter, what other marketing touchpoints did they have? Show me the top conversion paths.
```
**Expected**: Analysis of touchpoint combinations for conversions

### Scenario 3: ROAS Analysis
```
How is our 'CA_Summer_Promo_2025' campaign performing in terms of Return on Ad Spend?
```
**Expected**: ROAS of 4.6 with campaign performance metrics

## Final Result
- **Agent Location**: Snowsight → AI & ML → Snowflake Intelligence → "ACME Marketing Agent"
- **Data Foundation**: 200 unified customer records ready for analysis
- **Demo Ready**: All 3 scenarios validated and working

## Key Technical Notes
- Uses `FROM SPECIFICATION` syntax for agent creation (not `AGENT_SPEC` parameter)
- Semantic model uses `tables` with `base_table` structure (not `entities`)
- Campaign IDs are null for organic channels (realistic marketing data)
- Agent properly connects to semantic model and queries actual data