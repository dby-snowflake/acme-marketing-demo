# 🎯 ACME Marketing Intelligence Agent - Complete Implementation

## Overview
This document describes the complete implementation of the ACME Marketing Intelligence Agent with four powerful tools for comprehensive marketing analytics.

## Agent Architecture

### 🔧 Four-Tool Configuration

1. **ACMEMarketingAnalyst** (Cortex Analyst Text-to-SQL)
   - Analyzes live customer data from `CUSTOMER_360_VIEW`
   - Provides real-time metrics, ROAS, lead analysis
   - Semantic Model: `acme_semantic_model.yaml`

2. **EmailSentimentAnalyzer** (Cortex Analyst Text-to-SQL) 
   - AI sentiment analysis of customer email responses
   - Uses `SNOWFLAKE.CORTEX.SENTIMENT()` and `SNOWFLAKE.CORTEX.SUMMARIZE()`
   - Semantic Model: `sentiment_semantic_model.yaml`

3. **MarketingKnowledgeSearch** (Cortex Search)
   - Searches marketing documents, campaign briefs, strategies
   - Access to competitive intelligence and process guides
   - Search Service: `marketing_knowledge_search`

4. **Market_Research** (Web Search)
   - Industry benchmarks and CAC data
   - Current market trends and competitive analysis
   - Max 10 results, 30-second timeout

## Database Schema

### Tables Created

#### 1. Marketing Documents (`marketing_documents`)
```sql
CREATE TABLE marketing_documents (
    doc_id VARCHAR(50),
    title VARCHAR(200),
    content TEXT,
    document_type VARCHAR(50),
    campaign_name VARCHAR(100),
    created_date DATE,
    author VARCHAR(100),
    tags VARCHAR(500)
);
```

**Documents Added:**
- CA Summer Promo 2025 Campaign Brief
- Holiday Solar Sale Strategy  
- Battery Storage Market Analysis
- Lead Reactivation Playbook
- Competitive Analysis Q1 2025

#### 2. Email Campaigns (`email_campaigns`)
```sql
CREATE TABLE email_campaigns (
    email_id VARCHAR(50),
    campaign_name VARCHAR(100),
    email_subject VARCHAR(200),
    email_body TEXT,
    send_date DATE,
    recipient_segment VARCHAR(50),
    sender VARCHAR(100),
    email_type VARCHAR(50),
    open_rate DECIMAL(5,2),
    click_rate DECIMAL(5,2),
    conversion_rate DECIMAL(5,2)
);
```

**Campaigns Added:**
- CA_Summer_Promo_2025 (Promotional)
- Holiday_Solar_Sale (Urgency)
- Battery_Storage_Push (Educational)
- Lead_Reactivation (Reactivation)

#### 3. Customer Email Responses (`customer_email_responses`)
```sql
CREATE TABLE customer_email_responses (
    response_id VARCHAR(50),
    email_id VARCHAR(50),
    customer_email VARCHAR(100),
    response_text TEXT,
    response_date TIMESTAMP,
    response_type VARCHAR(50),
    lead_id VARCHAR(50),
    resulted_in_conversion BOOLEAN
);
```

**Response Types:**
- Positive Inquiry, Negative Complaint
- Cautious Interest, Conversion Ready
- Problem Aware, Neutral Inquiry
- Appreciative, Urgent Need
- Resistant Pressure, Educational Request

### Views Created

#### 1. Email Sentiment Analysis (`email_sentiment_analysis`)
```sql
CREATE OR REPLACE VIEW email_sentiment_analysis AS
SELECT 
    r.*,
    e.campaign_name,
    e.email_subject,
    e.email_type,
    e.recipient_segment,
    SNOWFLAKE.CORTEX.SENTIMENT(r.response_text) as ai_sentiment_score,
    CASE 
        WHEN SNOWFLAKE.CORTEX.SENTIMENT(r.response_text) >= 0.5 THEN 'Positive'
        WHEN SNOWFLAKE.CORTEX.SENTIMENT(r.response_text) <= -0.5 THEN 'Negative'
        ELSE 'Neutral'
    END as sentiment_category,
    SNOWFLAKE.CORTEX.SUMMARIZE(r.response_text) as response_summary
FROM customer_email_responses r
LEFT JOIN email_campaigns e ON r.email_id = e.email_id;
```

#### 2. Campaign Sentiment Insights (`campaign_sentiment_insights`)
Aggregated view showing:
- Average sentiment score per campaign
- Positive/negative/neutral response counts and percentages
- Conversion correlation with sentiment
- Performance metrics (open rate, click rate, conversion rate)

## Search Service

### Cortex Search Service
```sql
CREATE CORTEX SEARCH SERVICE marketing_knowledge_search
ON content 
ATTRIBUTES title, document_type, campaign_name, author, tags
WAREHOUSE = SNOWFLAKE_INTELLIGENCE_WH
TARGET_LAG = '1 hour'
```

## Agent Configuration

### Agent Creation
```sql
CREATE AGENT "ACME Marketing Agent"
WITH PROFILE='{"display_name": "ACME Marketing Agent"}'
COMMENT='ACME marketing intelligence agent with customer data analysis, marketing document search, sentiment analysis of customer responses, and web search for CAC benchmarking'
FROM SPECIFICATION $$
{
    "models": { "orchestration": "auto" },
    "instructions": {
        "response": "You are an ACME marketing expert with comprehensive access to customer data, marketing documents, and customer sentiment analysis...",
        "orchestration": "Use ACMEMarketingAnalyst for customer data analysis. Use EmailSentimentAnalyzer for analyzing customer email responses..."
    },
    "tools": [
        { "tool_spec": { "type": "cortex_analyst_text_to_sql", "name": "ACMEMarketingAnalyst" } },
        { "tool_spec": { "type": "cortex_analyst_text_to_sql", "name": "EmailSentimentAnalyzer" } },
        { "tool_spec": { "type": "cortex_search", "name": "MarketingKnowledgeSearch" } },
        { "tool_spec": { "type": "web_search", "name": "Market_Research" } }
    ],
    "tool_resources": {
        "ACMEMarketingAnalyst": { "semantic_model_file": "@snowflake_intelligence.config.semantic_models/acme_semantic_model.yaml" },
        "EmailSentimentAnalyzer": { "semantic_model_file": "@snowflake_intelligence.config.semantic_models/sentiment_semantic_model.yaml" },
        "MarketingKnowledgeSearch": { "name": "SNOWFLAKE_INTELLIGENCE.MARKETING_ANALYSIS.marketing_knowledge_search", "max_results": 5 },
        "Market_Research": { "max_results": 10, "search_timeout_seconds": 30 }
    }
}
$$;
```

## Sample Questions by Agent Tool

### 📊 ACMEMarketingAnalyst (Cortex Analyst - Customer Data)
**Purpose**: Analyzes live customer data, leads, campaigns, conversions, and website engagement

**Sample Questions:**
- "I want to re-activate old leads. Pull a list of high-potential leads from the last year who did not convert and did not have a bad cancellation reason. Prioritize those who were highly engaged on our website."
- "How is our 'CA_Summer_Promo_2025' campaign performing in terms of Return on Ad Spend?"
- "What is our overall marketing ROI across all campaigns?"
- "Show me leads by source and engagement level for targeting"
- "For customers who converted last quarter, what other marketing touchpoints did they have? Show me the top conversion paths."
- "Which campaigns drove the most conversions and best ROAS last 30 days?"
- "Create a reactivation cohort for last 270 days up to 500 leads"
- "Show me the breakdown of leads by engagement level and conversion status"

### 🤖 EmailSentimentAnalyzer (Cortex Analyst - Sentiment Analysis)
**Purpose**: Analyzes customer email responses using AI sentiment analysis to understand customer reactions

**Sample Questions:**
- "Analyze the sentiment of customer responses to our recent email campaigns. Which campaigns are generating positive vs negative reactions?"
- "What does customer feedback tell us about our Holiday Solar Sale messaging?"
- "Find customers with negative sentiment responses and identify common concerns"
- "Which email campaigns have the best sentiment scores and conversion rates?"
- "Compare sentiment of urgent vs educational messaging approaches"
- "Show me all customers who responded negatively to promotional emails and their specific concerns"
- "What's the correlation between customer sentiment and actual conversions?"
- "Which email subject lines generate the most positive customer sentiment?"

### 🔍 MarketingKnowledgeSearch (Cortex Search - Document Search)
**Purpose**: Searches marketing documents, campaign briefs, strategies, playbooks, and competitive intelligence

**Sample Questions:**
- "Find our lead reactivation playbook and best practices"
- "What does our competitive analysis say about Tesla and Sunrun?"
- "Search for our CA Summer Promo 2025 campaign brief and show me the target audience details"
- "What does our Holiday Solar Sale strategy document say about messaging approach?"
- "Find our battery storage market analysis and competitive landscape information"
- "Search for competitive intelligence on Tesla Powerwall pricing strategy"
- "What competitive advantages do we have according to our analysis documents?"
- "Find our lead scoring methodology and criteria"
- "Search for our ROI calculator methodology and how it works"

### 🌐 Market_Research (Web Search - Industry Benchmarks)
**Purpose**: Searches the web for industry benchmarks, competitive analysis, and current market trends including CAC data

**Sample Questions:**
- "What are current industry average CAC rates for solar/renewable energy companies?"
- "How does our customer acquisition cost compare to industry benchmarks?"
- "Find current solar industry sentiment analysis best practices"
- "What are competitors spending on customer acquisition in renewable energy?"
- "Search for current solar market trends and growth projections for 2025"
- "Find industry benchmarks for email marketing performance in the solar industry"
- "What are current best practices for lead reactivation in B2B solar sales?"

## Combined Multi-Tool Intelligence Questions

### Strategy + Data + Sentiment Analysis
- "Find our lead reactivation playbook, analyze sentiment of recent reactivation campaign responses, and identify high-potential leads for a new campaign"
- "Use our competitive analysis to understand why customers mention Tesla in negative responses, then find leads interested in battery storage"
- "Compare our CA Summer Promo campaign brief projections with actual customer sentiment data and ROAS performance"

### Performance Optimization
- "Search for our Holiday Solar Sale strategy, compare with customer sentiment results, and benchmark against industry CAC rates"
- "Find our email marketing best practices, analyze how well we're following them based on sentiment, and get current industry benchmarks"
- "Analyze our battery storage market research, correlate with customer interest levels, and compare with competitor positioning"

## Key Results

### Sentiment Analysis Insights
- **Reactivation Messaging**: Highest sentiment (0.329) but 0% conversion
- **Educational Messaging**: Good sentiment (0.225), builds trust but no urgency
- **Urgency Messaging**: Lower sentiment (0.111) but drives action (33% conversion)
- **Promotional Messaging**: Lowest sentiment (0.013) but highest conversions (67%)

### The Sentiment-Conversion Paradox
Higher sentiment ≠ Higher conversions. Educational messaging creates positive feelings but promotional messaging drives sales.

## Quick Setup

### Demo Setup Script
Run the complete setup script to create the entire marketing intelligence agent:

```sql
-- Execute: 11_create_marketing_intelligence_agent.sql
```

This script creates:
- All database tables and sample data
- AI sentiment analysis views
- Cortex Search service
- Complete 4-tool agent configuration
- Verification queries

### Manual Setup Steps
1. **Run Setup Script**: Execute `11_create_marketing_intelligence_agent.sql`
2. **Upload Semantic Model**: 
   ```sql
   USE SCHEMA SNOWFLAKE_INTELLIGENCE.CONFIG;
   PUT file:///path/to/sentiment_semantic_model.yaml @semantic_models AUTO_COMPRESS=FALSE OVERWRITE=TRUE;
   ```
3. **Verify Agent**: Check Snowsight → AI & ML → Agents

## Agent Location
- **Snowsight UI**: AI & ML → Agents → "ACME Marketing Agent"
- **Full Path**: `SNOWFLAKE_INTELLIGENCE.AGENTS."ACME Marketing Agent"`

## Files Created

### SQL Scripts
- `11_create_marketing_intelligence_agent.sql` - Complete setup script

### Snowflake Objects
- **Tables**: `marketing_documents`, `email_campaigns`, `customer_email_responses`
- **Views**: `email_sentiment_analysis`, `campaign_sentiment_insights`
- **Search Service**: `marketing_knowledge_search`
- **Agent**: `"ACME Marketing Agent"` with 4 tools

### Semantic Models
- `@snowflake_intelligence.config.semantic_models/`
  - `acme_semantic_model.yaml`
  - `sentiment_semantic_model.yaml`
