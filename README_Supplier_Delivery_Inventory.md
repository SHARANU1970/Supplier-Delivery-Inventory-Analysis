# Supplier Delivery Performance & Inventory Analysis

## Project Overview

This project analyzes supplier delivery performance and inventory conditions using SQL and Excel.

The analysis covers 3,200+ purchase orders across 15 suppliers and evaluates delivery reliability, supplier risk, inventory movement, and stockout patterns.

The objective is to identify underperforming suppliers, understand inventory risks, and provide data-driven recommendations for improving supplier performance and inventory planning.

## Business Objectives

- Measure supplier on-time delivery performance.
- Identify suppliers with consistently late deliveries.
- Compare supplier performance across product categories.
- Analyze purchase-order value and delivery delays.
- Evaluate inventory demand and stockout rates.
- Identify high-risk suppliers and inventory problem areas.
- Provide actionable recommendations for procurement and inventory management.

## Dataset

- **3,200+ unique purchase orders**
- **15 suppliers**
- Product category analysis
- Delivery performance information
- Inventory and stockout information

The raw dataset intentionally contains duplicate records and missing values to demonstrate a realistic data-cleaning workflow.

> **Data note:** This is a generated portfolio/demo dataset created for analytics practice. It does not contain confidential company information or real supplier data.

## Tools & Technologies

- **SQL / MySQL**
- **Microsoft Excel**
- Data Cleaning
- Exploratory Data Analysis
- KPI Analysis
- Supplier Performance Analysis
- Inventory Analysis

## SQL Analysis

The SQL analysis includes:

- Duplicate purchase-order identification
- Missing-value analysis
- Duplicate removal using `ROW_NUMBER()`
- Supplier on-time delivery KPIs
- Average late-delivery days
- Chronically late supplier identification
- Supplier and category analysis using `JOIN`
- Inventory demand and stockout analysis
- Supplier risk ranking using `CTE` and `RANK()`
- Aggregations, `CASE`, `GROUP BY`, and `HAVING`

## Key Findings

The analysis highlights:

- An overall **35.5% on-time delivery rate**.
- **3 suppliers** identified as chronically late based on consistently poor on-time performance.
- Significant differences in supplier reliability and average delivery delays.
- Inventory pressure in high-demand product categories.
- A **64.7% stockout rate** in the highest-demand category.
- Supplier delivery reliability can affect inventory availability and stockout risk.

> The percentages above are calculated from the generated portfolio dataset and are intended for demonstration purposes.

## Business Recommendations

1. **Review chronically late suppliers**
   - Establish supplier performance targets.
   - Conduct regular supplier performance reviews.
   - Consider alternative suppliers where reliability remains poor.

2. **Improve inventory planning**
   - Increase safety-stock levels for high-demand categories.
   - Monitor stockout rates regularly.
   - Align replenishment schedules with demand patterns.

3. **Use supplier KPIs**
   - Track on-time delivery percentage.
   - Monitor average delay days.
   - Evaluate supplier performance by category.

4. **Reduce supply-chain risk**
   - Develop backup suppliers for critical categories.
   - Prioritize suppliers with stronger delivery reliability.
   - Use historical performance when planning future purchases.

## Project Structure

```text
Supplier-Delivery-Inventory-Analysis/
├── data/
│   ├── supplier_delivery_inventory_raw.csv
│   └── supplier_delivery_inventory_clean.csv
├── sql/
│   └── supplier_delivery_inventory.sql
├── excel/
│   └── Supplier_Delivery_Inventory_Analysis.xlsx
├── README.md
└── data_dictionary.md
```

## Files Description

### `supplier_delivery_inventory_raw.csv`
Original portfolio dataset containing intentionally introduced duplicate records and missing values.

### `supplier_delivery_inventory_clean.csv`
Cleaned dataset used for analysis.

### `supplier_delivery_inventory.sql`
SQL queries for data cleaning, supplier KPI analysis, inventory analysis, joins, CTEs, and window functions.

### `Supplier_Delivery_Inventory_Analysis.xlsx`
Excel-based analysis and KPI summaries.

### `data_dictionary.md`
Definitions and explanations for dataset columns.

## Resume Project Description

**Supplier Delivery Performance & Inventory Analysis**

> Analyzed 3,200+ purchase orders across 15 suppliers to evaluate delivery reliability and inventory risk using SQL and Excel. Calculated on-time delivery rates, supplier-level KPIs, and inventory turnover/stockout metrics; identified 3 chronically late suppliers and a 64.7% stockout rate in the highest-demand category. Translated findings into supplier risk and inventory planning recommendations.

**Tech Stack:** SQL, MySQL, Excel, Data Cleaning, KPI Analysis, Inventory Analysis
