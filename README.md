# Shipping Cost Intelligence System

A Brainforge-style analytics case study that simulates how a growth-stage retailer could consolidate fragmented carrier data into a single decision-support system for logistics optimization, surcharge analysis, and carrier negotiation readiness.

## Why this project exists

Brainforge highlights work that turns ambiguous operational problems into practical systems that improve decision-making. In one of its retail case studies, the firm describes consolidating multi-carrier shipping data, calculating true cost-per-pound and cost-per-shipment, and modeling proposed carrier rates to unlock six-figure savings. This project mirrors that style of engagement with a larger synthetic dataset and a structured SQL modeling layer.

## Project objective

Build a reporting-ready analytics layer that helps an operations team answer:

- What is the true cost per shipment and cost per billed pound?
- Which carriers and service levels are most cost-efficient?
- Which lanes and zones carry the highest surcharge burden?
- How often is billed weight materially above actual package weight?
- What savings could be realized under proposed carrier rates?

## Dataset contents

- `shipments.csv` — 5,000 historical shipments across 2024–2025
- `carriers.csv` — carrier master data
- `rate_cards.csv` — current contracted rate bands by carrier, service level, zone, and weight band
- `proposed_rates.csv` — proposed rate bands for negotiation scenario modeling

## SQL models

- `01_stg_shipments.sql`
- `02_shipping_cost_metrics.sql`
- `03_surcharge_analysis.sql`
- `04_carrier_performance.sql`
- `05_lane_cost_analysis.sql`
- `06_rate_change_scenario_model.sql`
- `07_executive_summary.sql`

## Suggested Tableau dashboard

Title: **Shipping Cost Intelligence Dashboard**

KPI cards:
- Total Shipping Spend
- Cost per Shipment
- Cost per Billed Pound
- Surcharge % of Cost
- Projected Savings Under Proposed Rates

Core visuals:
- Monthly shipping spend trend
- Carrier/service-level comparison
- Surcharge burden by zone
- Lane cost heatmap
- Billed-vs-actual weight mismatch analysis
- Savings waterfall or bar chart for proposed-rate scenario

## AI extension idea

An AI-assisted workflow could ingest messy PDF carrier rate sheets, extract rate bands into structured tables, and automatically compare them against historical shipment patterns to quantify negotiation opportunities.
