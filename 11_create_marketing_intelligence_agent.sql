-- =============================================================================
-- ACME MARKETING INTELLIGENCE AGENT - COMPLETE SETUP SCRIPT
-- Creates 4-tool marketing intelligence agent with sentiment analysis
-- =============================================================================

USE ROLE SNOWFLAKE_INTELLIGENCE_ADMIN_RL;
USE DATABASE SNOWFLAKE_INTELLIGENCE;

-- =============================================================================
-- STEP 1: CREATE MARKETING DOCUMENTS TABLE AND DATA
-- =============================================================================
USE SCHEMA MARKETING_ANALYSIS;

-- Create marketing documents table
CREATE TABLE IF NOT EXISTS marketing_documents (
    doc_id VARCHAR(50),
    title VARCHAR(200),
    content TEXT,
    document_type VARCHAR(50),
    campaign_name VARCHAR(100),
    created_date DATE,
    author VARCHAR(100),
    tags VARCHAR(500)
);

-- Insert marketing documents
INSERT INTO marketing_documents VALUES 
('DOC001', 'CA Summer Promo 2025 Campaign Brief', 'The CA Summer Promo 2025 campaign targets California homeowners interested in solar energy solutions. Key messaging focuses on summer energy savings, federal tax credits, and local incentives. Target audience: homeowners aged 35-65 with household income 75K+. Channel mix includes Google Ads, Facebook, and direct mail. Budget: 50K over 3 months. Expected ROAS: 4:1. Key metrics: lead generation, cost per lead, conversion rate.', 'Campaign Brief', 'CA_Summer_Promo_2025', '2025-06-01', 'Marketing Team', 'solar,california,summer,promo,tax-credits,homeowners'),
('DOC002', 'Holiday Solar Sale Strategy', 'Holiday Solar Sale campaign leverages end-of-year urgency and tax incentive deadlines. Messaging emphasizes year-end savings and installation before December 31st for maximum tax benefits. Multi-channel approach with emphasis on digital channels and retargeting website visitors. Budget allocation: 60% digital, 30% traditional, 10% events.', 'Campaign Strategy', 'Holiday_Solar_Sale', '2024-10-15', 'Strategy Team', 'holiday,solar,tax-incentives,year-end,digital-marketing'),
('DOC003', 'Battery Storage Market Analysis', 'Battery storage adoption increasing 40% YoY. Key drivers: grid reliability concerns, time-of-use rates, backup power needs. Target segments: existing solar customers, high electricity usage homes, areas with frequent outages. Competitive landscape dominated by Tesla Powerwall, LG Chem, Enphase. Pricing strategy should emphasize value over lowest cost.', 'Market Research', 'Battery_Storage_Push', '2025-03-15', 'Research Team', 'battery,storage,market-analysis,competition,tesla,powerwall'),
('DOC004', 'Lead Reactivation Playbook', 'Framework for reactivating dormant leads older than 90 days. Segmentation based on engagement level, lead source, and reason for initial decline. Multi-touch sequence includes email, phone, retargeting. Success metrics: reactivation rate 15%, conversion rate 8%. Avoid leads with bad cancellation reasons.', 'Process Guide', 'Lead_Reactivation', '2025-01-20', 'Sales Ops', 'lead-reactivation,segmentation,multi-touch,dormant-leads'),
('DOC005', 'Competitive Analysis Q1 2025', 'Major competitors: Sunrun, Tesla, SunPower. Sunrun leads in installations, Tesla in brand recognition, SunPower in premium segment. Our differentiation: local service, financing flexibility, battery integration. Pricing analysis shows competitive positioning in mid-market.', 'Competitive Intelligence', 'Competitive_Analysis', '2025-03-31', 'Intelligence Team', 'competitors,sunrun,tesla,sunpower,pricing,differentiation');

-- =============================================================================
-- STEP 2: CREATE EMAIL CAMPAIGNS TABLE AND DATA
-- =============================================================================

-- Create email campaigns table
CREATE TABLE IF NOT EXISTS email_campaigns (
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

-- Insert email campaigns
INSERT INTO email_campaigns VALUES 
('EMAIL001', 'CA_Summer_Promo_2025', 'Beat the Heat with Solar Savings', 'Summer is here and your energy bills are soaring! Take control with our limited-time California Summer Solar Promotion. Save up to 30% on your solar installation plus get federal tax credits. Our expert team will handle everything from permits to installation. Join thousands of happy customers who are already saving money and helping the environment. Act now - this amazing offer expires July 31st!', '2025-06-15', 'California Homeowners', 'ACME Solar Team', 'Promotional', 24.5, 8.2, 3.1),
('EMAIL002', 'Holiday_Solar_Sale', 'Last Chance for 2024 Tax Credits', 'Time is running out! December 31st is the deadline to qualify for maximum federal solar tax credits. Dont miss out on thousands in savings. Our team is standing by to help you go solar before the year ends. Free consultation and quote within 24 hours. Your future self will thank you for taking action today.', '2024-11-15', 'Tax Credit Eligible', 'ACME Solar Team', 'Urgency', 32.1, 12.4, 5.7),
('EMAIL003', 'Battery_Storage_Push', 'Power Through Outages with Confidence', 'Recent power outages in your area remind us how important energy independence is. Our battery storage solutions keep your lights on when the grid goes down. Protect your family with reliable backup power. Learn how our customers stayed powered during the last outage while neighbors went dark.', '2025-03-20', 'Outage Affected Areas', 'ACME Energy Solutions', 'Educational', 28.9, 9.1, 4.2),
('EMAIL004', 'Lead_Reactivation', 'We Miss You - Special Offer Inside', 'We noticed you were interested in solar but havent heard from you lately. As a valued prospect, we are extending a special 15% discount on installation costs. Our solar consultants are here to answer any questions and address concerns. No pressure - just honest advice about your energy future.', '2025-02-10', 'Dormant Leads', 'ACME Customer Success', 'Reactivation', 19.3, 6.8, 2.1);

-- =============================================================================
-- STEP 3: CREATE CUSTOMER EMAIL RESPONSES TABLE AND DATA
-- =============================================================================

-- Create customer email responses table
CREATE TABLE IF NOT EXISTS customer_email_responses (
    response_id VARCHAR(50),
    email_id VARCHAR(50),
    customer_email VARCHAR(100),
    response_text TEXT,
    response_date TIMESTAMP,
    response_type VARCHAR(50),
    lead_id VARCHAR(50),
    resulted_in_conversion BOOLEAN
);

-- Insert customer responses
INSERT INTO customer_email_responses VALUES 
('RESP001', 'EMAIL001', 'customer1@email.com', 'This sounds amazing! I have been looking for ways to reduce my electricity bill and help the environment. The 30% savings plus tax credits make this a no-brainer. When can we schedule a consultation? I am very excited about this opportunity!', '2025-06-16 09:15:00', 'Positive Inquiry', 'SF000045', true),
('RESP002', 'EMAIL001', 'customer2@email.com', 'Stop sending me these pushy sales emails! I already told your sales rep I am not interested. Your constant pressure tactics are annoying and unprofessional. Remove me from your list immediately or I will report this as spam.', '2025-06-16 14:22:00', 'Negative Complaint', 'SF000012', false),
('RESP003', 'EMAIL002', 'customer3@email.com', 'I am interested but worried about the quality of installation. My neighbor had issues with their solar company last year. What guarantees do you offer? Can you provide references from recent customers in my area?', '2024-11-16 11:30:00', 'Cautious Interest', 'SF000089', false),
('RESP004', 'EMAIL002', 'customer4@email.com', 'Thank you for the reminder about tax credit deadlines. We have been planning to go solar for months and this pushed us to finally act. Please send someone out for a site assessment next week. We are ready to move forward!', '2024-11-17 08:45:00', 'Conversion Ready', 'SF000134', true),
('RESP005', 'EMAIL003', 'customer5@email.com', 'The recent outage was a nightmare - no power for 18 hours with two young kids. Battery backup sounds like exactly what we need. However, I am concerned about the cost. Do you offer financing options? What is the typical payback period?', '2025-03-21 16:20:00', 'Problem Aware', 'SF000067', false),
('RESP006', 'EMAIL004', 'customer6@email.com', 'I appreciate you reaching out again. The 15% discount is tempting but I am still not convinced solar is right for my situation. My roof gets partial shade and I am not sure about the ROI. Can you provide a detailed analysis specific to my property?', '2025-02-11 10:12:00', 'Neutral Inquiry', 'SF000023', false),
('RESP007', 'EMAIL003', 'customer7@email.com', 'Finally a company that understands real problems instead of just pushing sales! The outage information was helpful. I want to learn more about battery options but please no high-pressure sales calls. Email works better for me.', '2025-03-22 13:45:00', 'Appreciative', 'SF000156', false),
('RESP008', 'EMAIL001', 'customer8@email.com', 'Your email came at the perfect time! We just got our summer electric bill and it was shocking - over 400 dollars! I need solar ASAP. What is the fastest timeline for installation? Money is tight but this bill is killing us.', '2025-06-18 07:30:00', 'Urgent Need', 'SF000078', true),
('RESP009', 'EMAIL002', 'customer9@email.com', 'The tax credit info is useful but your email feels rushed and pushy. I need time to research and compare options. Deadline pressure makes me want to wait until next year when I can make a better decision.', '2024-11-18 15:55:00', 'Resistant Pressure', 'SF000091', false),
('RESP010', 'EMAIL004', 'customer10@email.com', 'Thanks for staying in touch. Life got busy and solar fell off my radar. The discount is nice but what I really need is education about how this works with HOA approval and financing. Can you send some resources?', '2025-02-12 12:20:00', 'Educational Request', 'SF000145', false);

-- =============================================================================
-- STEP 4: CREATE AI SENTIMENT ANALYSIS VIEWS
-- =============================================================================

-- Create email sentiment analysis view with AI functions
CREATE OR REPLACE VIEW email_sentiment_analysis AS
SELECT 
    r.response_id,
    r.email_id,
    r.customer_email,
    r.response_text,
    r.response_date,
    r.response_type,
    r.lead_id,
    r.resulted_in_conversion,
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

-- Create campaign sentiment insights view
CREATE OR REPLACE VIEW campaign_sentiment_insights AS
SELECT 
    e.campaign_name,
    e.email_subject,
    e.email_type,
    e.recipient_segment,
    COUNT(*) as total_responses,
    AVG(SNOWFLAKE.CORTEX.SENTIMENT(r.response_text)) as avg_sentiment_score,
    COUNT(CASE WHEN SNOWFLAKE.CORTEX.SENTIMENT(r.response_text) >= 0.5 THEN 1 END) as positive_responses,
    COUNT(CASE WHEN SNOWFLAKE.CORTEX.SENTIMENT(r.response_text) <= -0.5 THEN 1 END) as negative_responses,
    COUNT(CASE WHEN SNOWFLAKE.CORTEX.SENTIMENT(r.response_text) BETWEEN -0.5 AND 0.5 THEN 1 END) as neutral_responses,
    ROUND((COUNT(CASE WHEN SNOWFLAKE.CORTEX.SENTIMENT(r.response_text) >= 0.5 THEN 1 END) * 100.0 / COUNT(*)), 2) as positive_percentage,
    ROUND((COUNT(CASE WHEN SNOWFLAKE.CORTEX.SENTIMENT(r.response_text) <= -0.5 THEN 1 END) * 100.0 / COUNT(*)), 2) as negative_percentage,
    COUNT(CASE WHEN r.resulted_in_conversion = true THEN 1 END) as conversions,
    e.open_rate,
    e.click_rate,
    e.conversion_rate
FROM email_campaigns e
LEFT JOIN customer_email_responses r ON e.email_id = r.email_id
GROUP BY e.campaign_name, e.email_subject, e.email_type, e.recipient_segment, e.open_rate, e.click_rate, e.conversion_rate;

-- =============================================================================
-- STEP 5: CREATE CORTEX SEARCH SERVICE
-- =============================================================================

-- Create Cortex Search service for marketing documents
CREATE CORTEX SEARCH SERVICE marketing_knowledge_search
ON content 
ATTRIBUTES title, document_type, campaign_name, author, tags
WAREHOUSE = SNOWFLAKE_INTELLIGENCE_WH
TARGET_LAG = '1 hour'
AS (
    SELECT content, title, document_type, campaign_name, author, tags 
    FROM marketing_documents
);

-- =============================================================================
-- STEP 6: UPLOAD SEMANTIC MODEL FOR SENTIMENT ANALYSIS
-- =============================================================================

USE SCHEMA CONFIG;

-- Note: The sentiment_semantic_model.yaml file needs to be uploaded manually
-- PUT file:///path/to/sentiment_semantic_model.yaml @semantic_models AUTO_COMPRESS=FALSE OVERWRITE=TRUE;

-- =============================================================================
-- STEP 7: CREATE MARKETING INTELLIGENCE AGENT
-- =============================================================================

USE SCHEMA AGENTS;

-- Create the ACME Marketing Intelligence Agent with 4 tools
CREATE OR REPLACE AGENT "ACME Marketing Agent"
WITH PROFILE='{"display_name": "ACME Marketing Agent"}'
    COMMENT='ACME marketing intelligence agent with customer data analysis, marketing document search, sentiment analysis of customer responses, and web search for CAC benchmarking'
FROM SPECIFICATION $$
{
    "models": { "orchestration": "auto" },
    "instructions": {
        "response": "You are an ACME marketing expert with comprehensive access to customer data, marketing documents, and customer sentiment analysis. You can analyze customer responses to email campaigns using AI sentiment analysis to understand how customers feel about our messaging. Always query actual data to provide specific insights with real numbers. When analyzing lead reactivation, focus on leads with reactivation_potential = 'High Potential' from the last year. For ROAS analysis, calculate return on ad spend using contract_value divided by daily_spend. For customer sentiment, use the email sentiment analysis views to understand customer reactions to campaigns. When asked about industry benchmarks like CAC, use web search. When asked about campaign strategies or competitive intelligence, use marketing knowledge search.",
        "orchestration": "Use ACMEMarketingAnalyst for customer data analysis. Use EmailSentimentAnalyzer for analyzing customer email responses and campaign sentiment insights. Use MarketingKnowledgeSearch for campaign strategies and competitive intelligence. Use Market_Research for industry benchmarks and current trends. Always provide specific numbers and actionable insights.",
        "sample_questions": [
            {"question": "I want to re-activate old leads. Pull a list of high-potential leads from the last year who did not convert and did not have a bad cancellation reason."},
            {"question": "How is our CA_Summer_Promo_2025 campaign performing in terms of Return on Ad Spend?"},
            {"question": "Analyze the sentiment of customer responses to our recent email campaigns. Which campaigns are generating positive vs negative reactions?"},
            {"question": "What does customer feedback tell us about our Holiday Solar Sale messaging?"},
            {"question": "Find customers with negative sentiment responses and identify common concerns"},
            {"question": "Which email campaigns have the best sentiment scores and conversion rates?"},
            {"question": "Compare sentiment of urgent vs educational messaging approaches"},
            {"question": "What are current industry average CAC rates for solar companies?"}
        ]
    },
    "tools": [
        {
            "tool_spec": {
                "type": "cortex_analyst_text_to_sql",
                "name": "ACMEMarketingAnalyst",
                "description": "Analyzes ACME customer data including leads, campaigns, conversions, and website engagement for marketing insights"
            }
        },
        {
            "tool_spec": {
                "type": "cortex_analyst_text_to_sql",
                "name": "EmailSentimentAnalyzer",
                "description": "Analyzes customer email responses using AI sentiment analysis to understand customer reactions to campaigns"
            }
        },
        {
            "tool_spec": {
                "type": "cortex_search",
                "name": "MarketingKnowledgeSearch",
                "description": "Searches marketing documents, campaign briefs, strategies, playbooks, and competitive intelligence"
            }
        },
        {
            "tool_spec": {
                "type": "web_search",
                "name": "Market_Research",
                "description": "Searches the web for industry benchmarks, competitive analysis, and current market trends including CAC data"
            }
        }
    ],
    "tool_resources": {
        "ACMEMarketingAnalyst": {
            "semantic_model_file": "@snowflake_intelligence.config.semantic_models/acme_semantic_model.yaml"
        },
        "EmailSentimentAnalyzer": {
            "semantic_model_file": "@snowflake_intelligence.config.semantic_models/sentiment_semantic_model.yaml"
        },
        "MarketingKnowledgeSearch": {
            "name": "SNOWFLAKE_INTELLIGENCE.MARKETING_ANALYSIS.marketing_knowledge_search",
            "max_results": 5
        },
        "Market_Research": {
            "max_results": 10,
            "search_timeout_seconds": 30
        }
    }
}
$$;

-- =============================================================================
-- STEP 8: VERIFICATION QUERIES
-- =============================================================================

-- Verify marketing documents
SELECT 'Marketing Documents Created' as status, COUNT(*) as count FROM marketing_documents;

-- Verify email campaigns
SELECT 'Email Campaigns Created' as status, COUNT(*) as count FROM email_campaigns;

-- Verify customer responses
SELECT 'Customer Responses Created' as status, COUNT(*) as count FROM customer_email_responses;

-- Test sentiment analysis
SELECT 'Sentiment Analysis Test' as status;
SELECT 
    email_type,
    COUNT(*) as response_count,
    ROUND(AVG(ai_sentiment_score), 3) as avg_sentiment,
    COUNT(CASE WHEN sentiment_category = 'Positive' THEN 1 END) as positive_count,
    COUNT(CASE WHEN sentiment_category = 'Negative' THEN 1 END) as negative_count,
    COUNT(CASE WHEN resulted_in_conversion = true THEN 1 END) as conversions
FROM email_sentiment_analysis
GROUP BY email_type
ORDER BY avg_sentiment DESC;

-- Verify agent creation
SELECT 'Agent Status' as check_type, name, created_on 
FROM INFORMATION_SCHEMA.AGENTS 
WHERE name = 'ACME Marketing Agent';

SELECT '=== ACME Marketing Intelligence Agent Setup Complete ===' as final_status;
SELECT 'Agent Location: Snowsight → AI & ML → Agents → "ACME Marketing Agent"' as access_info;
