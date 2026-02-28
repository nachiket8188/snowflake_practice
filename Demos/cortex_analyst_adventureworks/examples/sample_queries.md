# 📝 Sample Queries for AdventureWorks Cortex Analyst

This document contains example natural language questions you can ask the Cortex Analyst, organized by analytics category.

---

## 📈 Revenue & Sales Analysis

### Basic Revenue Queries
| Question | What You'll Learn |
|----------|------------------|
| What is the total revenue? | Overall sales performance (~$109M) |
| What is the revenue by year? | Year-over-year growth trends |
| Show me monthly revenue trend | Seasonal patterns and momentum |
| What was the revenue in 2013? | Single year performance |

### Revenue Breakdown
| Question | What You'll Learn |
|----------|------------------|
| Revenue by product category | Which categories drive sales (Bikes dominate) |
| What is the revenue by territory? | Geographic performance |
| Compare online vs offline sales | Channel mix analysis |
| Revenue by sales representative | Individual rep performance |

---

## 🛒 Order Analysis

### Order Metrics
| Question | What You'll Learn |
|----------|------------------|
| How many orders do we have? | Total order volume (31K+) |
| What is the average order value? | Typical transaction size |
| How many orders per month? | Order volume trends |
| What's the average order value by year? | AOV trends over time |

### Order Patterns
| Question | What You'll Learn |
|----------|------------------|
| Which month had the most orders? | Peak periods |
| What percentage of orders are online? | Digital adoption |
| Show order count by territory | Geographic demand |

---

## 📦 Product Analysis

### Product Performance
| Question | What You'll Learn |
|----------|------------------|
| What are the top 10 products by revenue? | Best sellers |
| Which products sell the most units? | Volume leaders |
| What is the average unit price? | Pricing analysis |
| Top products in the Bikes category | Category-specific winners |

### Product Categories
| Question | What You'll Learn |
|----------|------------------|
| How many products in each category? | Product portfolio distribution |
| Revenue by product subcategory | Granular category performance |
| Which subcategories have the highest margins? | Profitability insights |

---

## 🌍 Geographic Analysis

### Territory Performance
| Question | What You'll Learn |
|----------|------------------|
| Revenue by sales territory | Regional performance |
| Which territory has the most orders? | Market demand by region |
| Compare North America vs Europe sales | Regional comparison |
| Top performing territory by revenue | Best market |

### Regional Trends
| Question | What You'll Learn |
|----------|------------------|
| Monthly revenue for Southwest territory | Territory trend |
| Which country generates the most revenue? | Country-level analysis |

---

## 👥 Sales Team Analysis

### Rep Performance
| Question | What You'll Learn |
|----------|------------------|
| Who are the top sales representatives? | Top performers |
| Revenue by sales person | Individual contributions |
| Which rep has the most orders? | Volume leaders |
| Average order value by sales rep | Rep efficiency |

### Quota & Performance
| Question | What You'll Learn |
|----------|------------------|
| What are the sales quotas? | Targets by rep |
| Which reps exceeded their quota? | Overachievers |
| Commission rates by sales person | Compensation structure |

---

## 👤 Customer Analysis

### Customer Metrics
| Question | What You'll Learn |
|----------|------------------|
| How many customers do we have? | Customer base size |
| Customers by territory | Geographic distribution |
| Top customers by revenue | Key accounts |

---

## 📊 Time-Based Analysis

### Trends & Comparisons
| Question | What You'll Learn |
|----------|------------------|
| Year over year revenue growth | Growth trajectory |
| Quarterly revenue comparison | Seasonal patterns |
| Best month for sales | Peak season |
| Revenue trend for 2013 | Single year trajectory |

### Specific Periods
| Question | What You'll Learn |
|----------|------------------|
| Q4 2013 revenue | Holiday season performance |
| First half vs second half 2013 | Half-year comparison |
| June 2014 sales | Most recent month |

---

## 🔀 Complex Multi-Table Queries

These questions demonstrate the power of the semantic model's relationships:

| Question | Tables Involved |
|----------|----------------|
| Revenue by product category and territory | Orders → Products → Categories + Territories |
| Top 5 sales reps with their territories and total revenue | Orders → SalesPersons → Persons → Territories |
| Which product categories do online customers prefer? | Orders → OrderDetails → Products → Categories |
| Customer count by territory with territory names | Customers → Territories |
| Average order value by product category | Orders → OrderDetails → Products → Categories |

---

## 💡 Tips for Better Results

1. **Be Specific**: "Revenue in 2013" works better than "sales last year"
2. **Use Business Terms**: The semantic model understands "revenue", "orders", "customers"
3. **Ask Follow-ups**: Build on previous answers for deeper analysis
4. **Try Variations**: If one phrasing doesn't work, try another

---

## 🚫 Queries That May Not Work

The current semantic model may struggle with:
- Complex date math ("same period last year")
- Percentile calculations
- Running totals / cumulative sums
- Queries about data not in the model (inventory, shipping details)

---

*Use these examples as a starting point - the power of Cortex Analyst is in asking your own questions!*
