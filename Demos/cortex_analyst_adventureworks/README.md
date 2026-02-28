# 🧠 AdventureWorks Sales Analytics with Cortex Analyst

A production-ready implementation of **Snowflake Cortex Analyst** demonstrating natural language querying over the AdventureWorks sales dataset. This project showcases how to build self-service analytics that allows business users to ask questions in plain English and receive accurate SQL-generated insights.

![Cortex Analyst Architecture](https://docs.snowflake.com/en/_images/cortex-analyst-overview.png)

## 🎯 Business Value

| Benefit | Description |
|---------|-------------|
| **Self-Service Analytics** | Business users ask questions without SQL knowledge |
| **Accurate Text-to-SQL** | Semantic model with 10 verified queries ensures reliable generation |
| **Multi-Table Intelligence** | Automatically joins across 9 related tables |
| **Governed Access** | Queries respect Snowflake RBAC policies |
| **Zero Infrastructure** | Fully managed by Snowflake |

## 📊 Use Cases Demonstrated

| Business Question | Analytics Capability |
|-------------------|---------------------|
| "What is the total revenue?" | Aggregation |
| "Show monthly revenue trend" | Time-series analysis |
| "Top 10 products by revenue" | Ranking |
| "Revenue by product category" | Dimensional analysis |
| "Compare online vs offline sales" | Channel comparison |
| "Who are the top sales representatives?" | Multi-table joins |
| "Revenue by sales territory" | Geographic analysis |

## 🏗️ Project Structure

```
cortex_analyst_adventureworks/
├── README.md                           # This file
├── semantic_models/
│   └── adventureworks_sales.yaml       # Semantic model (9 tables, 10 relationships)
├── setup/
│   └── 01_setup_infrastructure.sql     # Stage, permissions, and setup
├── app/
│   └── streamlit_analyst_app.py        # Interactive Streamlit demo
└── examples/
    └── sample_queries.md               # 50+ example business questions
```

## 🚀 Quick Start

### Step 1: Run Infrastructure Setup

```sql
-- Execute in Snowsight or your SQL client
-- This creates the stage for the semantic model

USE ROLE ACCOUNTADMIN;
USE DATABASE ADVENTUREWORKS;

CREATE STAGE IF NOT EXISTS CORTEX_ANALYST_STAGE
    DIRECTORY = (ENABLE = TRUE);
```

### Step 2: Upload Semantic Model

**Option A: Snowflake CLI (Recommended)**
```bash
snow stage copy semantic_models/adventureworks_sales.yaml \
  @ADVENTUREWORKS.PUBLIC.CORTEX_ANALYST_STAGE/
```

**Option B: Snowsight UI**
1. Navigate to **Data → Databases → ADVENTUREWORKS → PUBLIC → Stages**
2. Click **CORTEX_ANALYST_STAGE**
3. Click **+ Files** and upload `adventureworks_sales.yaml`

**Option C: PUT Command**
```sql
PUT file://./semantic_models/adventureworks_sales.yaml 
  @ADVENTUREWORKS.PUBLIC.CORTEX_ANALYST_STAGE
  AUTO_COMPRESS = FALSE OVERWRITE = TRUE;
```

### Step 3: Verify Upload

```sql
LIST @ADVENTUREWORKS.PUBLIC.CORTEX_ANALYST_STAGE;
```

### Step 4: Deploy Streamlit App

1. In Snowsight, go to **Streamlit** → **+ Streamlit App**
2. Copy contents of `app/streamlit_analyst_app.py`
3. Select ADVENTUREWORKS database and a warehouse
4. Click **Run**

## 📐 Semantic Model Architecture

### Tables Included (9)

| Table | Schema | Purpose | Rows |
|-------|--------|---------|------|
| `sales_orders` | SALES.SALESORDERHEADER | Order header data | 31,465 |
| `order_details` | SALES.SALESORDERDETAIL | Line items | 121,317 |
| `products` | PRODUCTION.PRODUCT | Product catalog | 504 |
| `product_categories` | PRODUCTION.PRODUCTCATEGORY | Top-level categories | 4 |
| `product_subcategories` | PRODUCTION.PRODUCTSUBCATEGORY | Subcategories | 37 |
| `customers` | SALES.CUSTOMER | Customer records | 19,820 |
| `persons` | PERSON.PERSON | Person names | 19,972 |
| `sales_territories` | SALES.SALESTERRITORY | Geographic regions | 10 |
| `sales_persons` | SALES.SALESPERSON | Sales representatives | 17 |

### Relationships (10)

```
sales_orders ──┬── order_details ──── products ──── product_subcategories ──── product_categories
               ├── customers ──────── persons
               ├── sales_territories
               └── sales_persons ──── persons
```

### Key Metrics

| Metric | Table | Description |
|--------|-------|-------------|
| `line_total` | order_details | Revenue per line item |
| `total_due` | sales_orders | Total order value |
| `quantity` | order_details | Units sold |
| `unit_price` | order_details | Selling price |
| `list_price` | products | Catalog price |
| `standard_cost` | products | Product cost |
| `sales_quota` | sales_persons | Rep targets |

### Verified Queries (10)

Pre-validated SQL patterns for common questions:
- Total revenue
- Revenue by year/month
- Top products by revenue
- Revenue by category
- Revenue by territory
- Order count by month
- Average order value
- Online vs offline comparison
- Top sales representatives

## 💡 Example Interactions

**User**: "What is the total revenue?"
```sql
-- Generated SQL
SELECT SUM(LINETOTAL) AS total_revenue
FROM ADVENTUREWORKS.SALES.SALESORDERDETAIL
```
**Result**: $109,846,381.40

---

**User**: "Top 5 products by revenue"
```sql
-- Generated SQL (joins across tables)
SELECT p.NAME, SUM(d.LINETOTAL) AS revenue
FROM ADVENTUREWORKS.SALES.SALESORDERDETAIL d
JOIN ADVENTUREWORKS.PRODUCTION.PRODUCT p ON d.PRODUCTID = p.PRODUCTID
GROUP BY p.NAME
ORDER BY revenue DESC
LIMIT 5
```

---

**User**: "Revenue by territory"
```sql
-- Automatically joins 3 tables
SELECT t.NAME AS territory, t."GROUP" AS region, SUM(h.TOTALDUE) AS revenue
FROM ADVENTUREWORKS.SALES.SALESORDERHEADER h
JOIN ADVENTUREWORKS.SALES.SALESTERRITORY t ON h.TERRITORYID = t.TERRITORYID
GROUP BY t.NAME, t."GROUP"
ORDER BY revenue DESC
```

## 🔐 Security & Governance

| Feature | Implementation |
|---------|----------------|
| **Data Access** | Queries run with caller's role permissions |
| **Semantic Model** | Stored in encrypted Snowflake stage |
| **RBAC Integration** | Optional CORTEX_ANALYST_USER role included |
| **Audit Trail** | All queries logged in Snowflake query history |
| **Data Privacy** | No customer data used for model training |

## 📈 Data Profile

| Metric | Value |
|--------|-------|
| **Date Range** | May 2011 - June 2014 |
| **Total Orders** | 31,465 |
| **Order Lines** | 121,317 |
| **Unique Products** | 266 |
| **Total Revenue** | ~$109M |
| **Territories** | 10 (US, Canada, Europe, Pacific) |
| **Sales Reps** | 17 |
| **Product Categories** | 4 (Bikes, Components, Clothing, Accessories) |

## 🛠️ Prerequisites

- Snowflake account with **Cortex Analyst enabled**
- `ACCOUNTADMIN` role (for setup) or equivalent permissions
- Access to ADVENTUREWORKS database with populated tables
- A warehouse for query execution

### Required Tables

Ensure these tables have data:
- `ADVENTUREWORKS.SALES.SALESORDERHEADER`
- `ADVENTUREWORKS.SALES.SALESORDERDETAIL`
- `ADVENTUREWORKS.PRODUCTION.PRODUCT`
- `ADVENTUREWORKS.PRODUCTION.PRODUCTCATEGORY`
- `ADVENTUREWORKS.PRODUCTION.PRODUCTSUBCATEGORY`
- `ADVENTUREWORKS.SALES.CUSTOMER`
- `ADVENTUREWORKS.PERSON.PERSON`
- `ADVENTUREWORKS.SALES.SALESTERRITORY`
- `ADVENTUREWORKS.SALES.SALESPERSON`

## 🧪 Testing the Setup

After deployment, test with these queries in the Streamlit app:

1. **Basic**: "What is the total revenue?"
2. **Aggregation**: "Show monthly revenue trend"
3. **Multi-table**: "Top 10 products by revenue"
4. **Complex join**: "Who are the top sales representatives?"

## 📚 Resources

| Resource | Link |
|----------|------|
| Cortex Analyst Docs | [docs.snowflake.com](https://docs.snowflake.com/en/user-guide/snowflake-cortex/cortex-analyst) |
| Semantic Model Spec | [Specification](https://docs.snowflake.com/user-guide/snowflake-cortex/cortex-analyst/semantic-model-spec) |
| REST API Reference | [API Docs](https://docs.snowflake.com/en/user-guide/snowflake-cortex/cortex-analyst/rest-api) |
| AdventureWorks Schema | [dataedo.com](https://dataedo.com/samples/html/AdventureWorks/) |

## 🤝 Contributing

Feel free to:
- Add more verified queries to the semantic model
- Extend the Streamlit app with new visualizations
- Create additional example queries

## 📄 License

MIT License - Feel free to use and adapt for your projects.

---

**Built with ❄️ Snowflake Cortex Analyst**

*For questions or issues, open a GitHub issue or contact the repository maintainer.*
