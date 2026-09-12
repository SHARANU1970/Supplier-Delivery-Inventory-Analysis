-- Supplier Delivery Performance & Inventory Analysis
-- MySQL 8+ | Portfolio / demo project

CREATE DATABASE IF NOT EXISTS supplier_inventory_analysis;
USE supplier_inventory_analysis;

-- ============================================================
-- 1. RAW DATA TABLE
-- Load supplier_delivery_inventory_raw.csv into this table.
-- ============================================================

CREATE TABLE IF NOT EXISTS purchase_orders_raw (
    PO_ID VARCHAR(30),
    PO_Date DATE,
    Supplier VARCHAR(100),
    Category VARCHAR(100),
    Quantity_Ordered INT,
    Unit_Cost DECIMAL(12,2),
    PO_Value DECIMAL(14,2),
    Promised_Delivery_Days INT,
    Actual_Delivery_Days INT,
    On_Time VARCHAR(10),
    Late_Days INT,
    Opening_Stock INT,
    Demand_Units INT,
    Received_Units INT,
    Closing_Stock INT,
    Stockout VARCHAR(10)
);

-- ============================================================
-- 2. DATA QUALITY CHECKS
-- ============================================================

-- Number of raw rows
SELECT COUNT(*) AS raw_rows
FROM purchase_orders_raw;

-- Duplicate purchase orders
SELECT
    PO_ID,
    COUNT(*) AS row_count
FROM purchase_orders_raw
GROUP BY PO_ID
HAVING COUNT(*) > 1
ORDER BY row_count DESC;

-- Missing-value profile
SELECT
    SUM(PO_ID IS NULL) AS missing_po_id,
    SUM(Supplier IS NULL) AS missing_supplier,
    SUM(Category IS NULL) AS missing_category,
    SUM(Quantity_Ordered IS NULL) AS missing_quantity,
    SUM(Unit_Cost IS NULL) AS missing_unit_cost,
    SUM(PO_Value IS NULL) AS missing_po_value,
    SUM(Promised_Delivery_Days IS NULL) AS missing_promised_days,
    SUM(Actual_Delivery_Days IS NULL) AS missing_actual_days,
    SUM(On_Time IS NULL) AS missing_on_time,
    SUM(Opening_Stock IS NULL) AS missing_opening_stock,
    SUM(Demand_Units IS NULL) AS missing_demand,
    SUM(Closing_Stock IS NULL) AS missing_closing_stock
FROM purchase_orders_raw;

-- ============================================================
-- 3. CLEAN DATA USING ROW_NUMBER()
-- Demonstrates a SQL window function to remove duplicates.
-- ============================================================

CREATE OR REPLACE VIEW purchase_orders_clean AS
WITH ranked_orders AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY PO_ID
            ORDER BY PO_Date, PO_ID
        ) AS rn
    FROM purchase_orders_raw
)
SELECT
    PO_ID,
    PO_Date,
    COALESCE(Supplier, 'Unknown') AS Supplier,
    COALESCE(Category, 'Unknown') AS Category,
    COALESCE(Quantity_Ordered, 0) AS Quantity_Ordered,
    COALESCE(Unit_Cost, 0) AS Unit_Cost,
    COALESCE(PO_Value, 0) AS PO_Value,
    COALESCE(Promised_Delivery_Days, 0) AS Promised_Delivery_Days,
    COALESCE(Actual_Delivery_Days, 0) AS Actual_Delivery_Days,
    COALESCE(On_Time, 'Unknown') AS On_Time,
    COALESCE(Late_Days, 0) AS Late_Days,
    COALESCE(Opening_Stock, 0) AS Opening_Stock,
    COALESCE(Demand_Units, 0) AS Demand_Units,
    COALESCE(Received_Units, 0) AS Received_Units,
    COALESCE(Closing_Stock, 0) AS Closing_Stock,
    COALESCE(Stockout, 'Unknown') AS Stockout
FROM ranked_orders
WHERE rn = 1;

-- ============================================================
-- 4. OVERALL DELIVERY KPI
-- ============================================================

SELECT
    COUNT(DISTINCT PO_ID) AS Total_Purchase_Orders,
    COUNT(DISTINCT Supplier) AS Total_Suppliers,
    ROUND(
        100 * SUM(On_Time = 'Yes') / NULLIF(COUNT(*), 0),
        1
    ) AS On_Time_Delivery_Rate_Pct,
    ROUND(AVG(Late_Days), 2) AS Average_Late_Days,
    SUM(PO_Value) AS Total_PO_Value
FROM purchase_orders_clean;

-- ============================================================
-- 5. SUPPLIER PERFORMANCE
-- ============================================================

SELECT
    Supplier,
    COUNT(DISTINCT PO_ID) AS Purchase_Orders,
    SUM(PO_Value) AS PO_Value,
    ROUND(
        100 * SUM(On_Time = 'Yes') / NULLIF(COUNT(*), 0),
        1
    ) AS On_Time_Rate_Pct,
    ROUND(AVG(Late_Days), 2) AS Avg_Late_Days,
    SUM(Late_Days) AS Total_Late_Days
FROM purchase_orders_clean
GROUP BY Supplier
ORDER BY On_Time_Rate_Pct ASC, Avg_Late_Days DESC;

-- ============================================================
-- 6. CHRONICALLY LATE SUPPLIERS
-- Suppliers with <30% on-time delivery and >=10 POs.
-- ============================================================

SELECT
    Supplier,
    COUNT(DISTINCT PO_ID) AS Purchase_Orders,
    ROUND(
        100 * SUM(On_Time = 'Yes') / NULLIF(COUNT(*), 0),
        1
    ) AS On_Time_Rate_Pct,
    ROUND(AVG(Late_Days), 2) AS Avg_Late_Days
FROM purchase_orders_clean
GROUP BY Supplier
HAVING COUNT(DISTINCT PO_ID) >= 10
   AND SUM(On_Time = 'Yes') / NULLIF(COUNT(*), 0) < 0.30
ORDER BY On_Time_Rate_Pct ASC;

-- ============================================================
-- 7. SUPPLIER + CATEGORY PERFORMANCE
-- Demonstrates SQL JOIN.
-- ============================================================

WITH supplier_kpi AS (
    SELECT
        Supplier,
        COUNT(DISTINCT PO_ID) AS Purchase_Orders,
        ROUND(
            100 * SUM(On_Time = 'Yes') / NULLIF(COUNT(*), 0),
            1
        ) AS On_Time_Rate_Pct
    FROM purchase_orders_clean
    GROUP BY Supplier
),
category_kpi AS (
    SELECT
        Supplier,
        Category,
        COUNT(DISTINCT PO_ID) AS Category_Orders,
        SUM(PO_Value) AS Category_PO_Value
    FROM purchase_orders_clean
    GROUP BY Supplier, Category
)
SELECT
    c.Supplier,
    c.Category,
    c.Category_Orders,
    c.Category_PO_Value,
    s.Purchase_Orders,
    s.On_Time_Rate_Pct
FROM category_kpi c
JOIN supplier_kpi s
    ON c.Supplier = s.Supplier
ORDER BY s.On_Time_Rate_Pct ASC, c.Category_PO_Value DESC;

-- ============================================================
-- 8. CATEGORY INVENTORY / STOCKOUT ANALYSIS
-- ============================================================

SELECT
    Category,
    SUM(Demand_Units) AS Total_Demand_Units,
    SUM(Opening_Stock) AS Opening_Stock,
    SUM(Received_Units) AS Received_Units,
    SUM(Closing_Stock) AS Closing_Stock,
    SUM(Stockout = 'Yes') AS Stockout_Records,
    COUNT(*) AS Total_Records,
    ROUND(
        100 * SUM(Stockout = 'Yes') / NULLIF(COUNT(*), 0),
        1
    ) AS Stockout_Rate_Pct,
    ROUND(
        SUM(Demand_Units) / NULLIF(AVG(Opening_Stock), 0),
        2
    ) AS Inventory_Turnover_Proxy
FROM purchase_orders_clean
GROUP BY Category
ORDER BY Stockout_Rate_Pct DESC;

-- ============================================================
-- 9. HIGHEST-DEMAND CATEGORY
-- ============================================================

SELECT
    Category,
    SUM(Demand_Units) AS Total_Demand_Units,
    ROUND(
        100 * SUM(Stockout = 'Yes') / NULLIF(COUNT(*), 0),
        1
    ) AS Stockout_Rate_Pct
FROM purchase_orders_clean
GROUP BY Category
ORDER BY Total_Demand_Units DESC
LIMIT 1;

-- ============================================================
-- 10. SUPPLIER RISK RANKING
-- Demonstrates CTE + WINDOW FUNCTION.
-- ============================================================

WITH supplier_metrics AS (
    SELECT
        Supplier,
        COUNT(DISTINCT PO_ID) AS Purchase_Orders,
        ROUND(
            100 * SUM(On_Time = 'Yes') / NULLIF(COUNT(*), 0),
            1
        ) AS On_Time_Rate_Pct,
        ROUND(AVG(Late_Days), 2) AS Avg_Late_Days,
        SUM(PO_Value) AS PO_Value
    FROM purchase_orders_clean
    GROUP BY Supplier
),
ranked_suppliers AS (
    SELECT
        *,
        RANK() OVER (
            ORDER BY On_Time_Rate_Pct ASC, Avg_Late_Days DESC
        ) AS Risk_Rank
    FROM supplier_metrics
)
SELECT
    Risk_Rank,
    Supplier,
    Purchase_Orders,
    On_Time_Rate_Pct,
    Avg_Late_Days,
    PO_Value,
    CASE
        WHEN On_Time_Rate_Pct < 30 THEN 'High Risk'
        WHEN On_Time_Rate_Pct < 50 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS Risk_Level
FROM ranked_suppliers
ORDER BY Risk_Rank;

-- ============================================================
-- 11. LATE DELIVERY FOLLOW-UP LIST
-- ============================================================

SELECT
    PO_ID,
    PO_Date,
    Supplier,
    Category,
    PO_Value,
    Promised_Delivery_Days,
    Actual_Delivery_Days,
    Late_Days
FROM purchase_orders_clean
WHERE On_Time = 'No'
ORDER BY Late_Days DESC, PO_Date DESC;

-- ============================================================
-- 12. STOCKOUT FOLLOW-UP LIST
-- ============================================================

SELECT
    PO_ID,
    PO_Date,
    Supplier,
    Category,
    Demand_Units,
    Opening_Stock,
    Received_Units,
    Closing_Stock
FROM purchase_orders_clean
WHERE Stockout = 'Yes'
ORDER BY Demand_Units DESC;

-- ============================================================
-- 13. EXECUTIVE SUMMARY
-- ============================================================

SELECT
    COUNT(DISTINCT PO_ID) AS Purchase_Orders,
    COUNT(DISTINCT Supplier) AS Suppliers,
    COUNT(DISTINCT Category) AS Categories,
    ROUND(100 * SUM(On_Time = 'Yes') / NULLIF(COUNT(*),0), 1)
        AS On_Time_Delivery_Pct,
    ROUND(AVG(Late_Days),2) AS Avg_Late_Days,
    SUM(PO_Value) AS Total_PO_Value,
    SUM(Demand_Units) AS Total_Demand_Units,
    SUM(Stockout = 'Yes') AS Stockout_Records,
    ROUND(100 * SUM(Stockout = 'Yes') / NULLIF(COUNT(*),0),1)
        AS Overall_Stockout_Rate_Pct
FROM purchase_orders_clean;

-- NOTE:
-- This project uses generated portfolio/demo data.
-- Metrics are intended for analytics demonstration and are not
-- real company or audited operational figures.
