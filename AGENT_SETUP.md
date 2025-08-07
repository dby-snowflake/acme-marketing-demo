# 🎯 ACME MARKETING AGENT - FINAL CONFIGURATION INSTRUCTIONS

## ✅ Current Status
- **Agent Created**: "ACME Marketing Agent" exists in Snowflake Intelligence
- **Data Foundation**: Complete with 200 unified customer records
- **Views Created**: `high_potential_leads_view` ready for use
- **Issue**: Agent needs tool configuration in Snowsight UI

## 🔧 REQUIRED: Configure Agent in Snowsight UI

The agent exists but needs to be configured with tools to access our demo data. Here's how:

### Step 1: Access Agent Configuration
1. Go to **Snowsight UI** → **AI & ML** → **Agents**
2. Find "**ACME Marketing Agent**" in the list
3. Click on the agent name
4. Click **"Edit"**

### Step 2: Add Tools for Data Access
The agent needs **Cortex Analyst** tool to access our demo data:

#### Add Cortex Analyst Tool:
1. Click **"Tools"** tab
2. Find **"Cortex Analyst"** and click **"+ Add"**
3. Configure:
   - **Name**: `acme_customer_data`
   - **Type**: Select **"Semantic view"** 
   - **Semantic View**: `SNOWFLAKE_INTELLIGENCE.MARKETING_ANALYSIS.CUSTOMER_360_VIEW`
   - **Warehouse**: Select your preferred warehouse (e.g., `COMPUTE_WH`)
   - **Query timeout**: `30` seconds
   - **Description**: "Unified customer data from Google Ads, Salesforce CRM, and website analytics for lead reactivation, ROAS analysis, and multi-touch attribution"

### Step 3: Configure Agent Instructions
1. Click **"Instructions"** tab
2. **Response instruction**: 
```
You are an ACME marketing expert with access to unified customer data from Google Ads, Salesforce CRM, and website analytics. Always query the actual data in customer_360_view to provide specific insights with real numbers. When analyzing lead reactivation, focus on leads with 'High Potential' reactivation_potential. For ROAS analysis, calculate based on contract_value divided by daily_spend. For multi-touch attribution, look for records where has_multi_touch_attribution = TRUE.
```

3. **Sample Questions** (Add these):
   - "I want to re-activate old leads. Pull a list of high-potential leads from the last year who didn't convert and didn't have a bad cancellation reason. Prioritize those who were highly engaged on our website."
   - "For customers who converted last quarter, what other marketing touchpoints did they have? Show me the top conversion paths."
   - "How is our 'CA_Summer_Promo_2025' campaign performing in terms of Return on Ad Spend?"

### Step 4: Configure Access
1. Click **"Access"** tab
2. Add roles that should have access to this agent
3. Click **"Save"**

## 🎯 Testing the Agent

After configuration, test these exact demo scenarios:

### Scenario 1: Lead Reactivation
**Prompt**: "I want to re-activate old leads. Pull a list of high-potential leads from the last year who didn't convert and didn't have a bad cancellation reason. Prioritize those who were highly engaged on our website."

**Expected Result**: Agent should return 58 high-potential leads with breakdown by source

### Scenario 2: Multi-Touch Attribution  
**Prompt**: "For customers who converted last quarter, what other marketing touchpoints did they have? Show me the top conversion paths."

**Expected Result**: Agent should show conversion paths and attribution data

### Scenario 3: ROAS Analysis
**Prompt**: "How is our 'CA_Summer_Promo_2025' campaign performing in terms of Return on Ad Spend?"

**Expected Result**: Agent should return ROAS of 4.6 with campaign performance data

## 📊 Demo Data Summary
- **Total Records**: 200 unified customer records
- **High-Potential Leads**: 58 leads ready for reactivation
- **Conversions**: 28 closed-won deals with multi-touch attribution
- **CA_Summer_Promo_2025**: ROAS of 4.6, $30,969 revenue, $6,706 spend

## 🚨 Why This Step is Critical
The agent was created via SQL but Snowflake Intelligence agents require UI configuration to:
- Add tools (Cortex Analyst/Search) for data access
- Set up semantic views/models
- Configure proper instructions and sample questions
- Enable the agent to actually query your data instead of giving generic responses

**Once configured in the UI, the agent will access the actual demo data and provide specific insights instead of generic marketing advice!**