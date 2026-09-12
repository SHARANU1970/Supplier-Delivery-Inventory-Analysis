# Data Dictionary

## Supplier Delivery Performance & Inventory Analysis

This document describes the fields included in the supplier delivery and inventory dataset.

> **Dataset note:** The dataset is a generated portfolio/demo dataset created for analytics practice. It is not real company or supplier data.

## Column Definitions

| Column | Data Type | Description |
|---|---|---|
| `PO_ID` | VARCHAR | Unique purchase-order identifier |
| `PO_Date` | DATE | Date on which the purchase order was created |
| `Supplier` | VARCHAR | Supplier associated with the purchase order |
| `Category` | VARCHAR | Product category associated with the purchase order |
| `Quantity_Ordered` | INTEGER | Number of units ordered |
| `Unit_Cost` | DECIMAL | Cost of one unit |
| `PO_Value` | DECIMAL | Total monetary value of the purchase order |
| `Promised_Delivery_Days` | INTEGER | Number of days promised by the supplier for delivery |
| `Actual_Delivery_Days` | INTEGER | Actual number of days taken for delivery |
| `On_Time` | VARCHAR | Indicates whether the purchase order was delivered on time |
| `Late_Days` | INTEGER | Number of days beyond the promised delivery period |
| `Opening_Stock` | INTEGER | Inventory available at the beginning of the analysis period |
| `Demand_Units` | INTEGER | Number of units demanded |
| `Received_Units` | INTEGER | Number of units received from the supplier |
| `Closing_Stock` | INTEGER | Inventory remaining after demand and receipts |
| `Stockout` | VARCHAR | Indicates whether inventory reached zero |

## Derived Metrics

### On-Time Delivery Rate

Percentage of purchase orders delivered on or before the promised delivery period.

```text
On-Time Delivery Rate =
(On-Time Purchase Orders / Total Purchase Orders) × 100
```

### Average Late Days

Average number of days by which late purchase orders exceeded the promised delivery period.

```text
Average Late Days =
Total Late Days / Number of Late Purchase Orders
```

### Stockout Rate

Percentage of records where available inventory reached zero.

```text
Stockout Rate =
Stockout Records / Total Records × 100
```

### Inventory Turnover Proxy

A simplified portfolio metric used to compare demand against average available inventory.

```text
Inventory Turnover Proxy =
Demand Units / Average Inventory
```

This is used for demonstration and should not be interpreted as an accounting-standard inventory turnover calculation.

### Supplier Risk Level

| On-Time Rate | Risk Level |
|---:|---|
| Below 30% | High Risk |
| 30%–49.99% | Medium Risk |
| 50% or above | Low Risk |

## Data Quality

The raw dataset intentionally contains:

- Duplicate purchase orders
- Missing supplier values
- Missing category values
- Missing unit-cost values
- Missing inventory-related values in selected records

The SQL workflow demonstrates how these issues can be identified and handled before KPI reporting.

## Important Data Note

All supplier names, purchase orders, inventory values, delivery metrics, and business results in this project are generated for portfolio demonstration purposes.

They should not be represented as actual data from a real company, supplier, or employer.
