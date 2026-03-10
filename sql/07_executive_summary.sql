WITH monthly_costs AS (
    SELECT
        DATE_TRUNC('month', CAST(ship_date AS DATE))          AS ship_month,
        COUNT(*)                                              AS total_shipments,
        SUM(total_shipping_cost)                              AS total_shipping_cost,
        SUM(billed_weight_lb)                                 AS total_billed_weight_lb,
        SUM(
            fuel_surcharge
            + residential_fee
            + delivery_area_fee
            + oversized_fee
            + address_correction_fee
            + ltl_handling_fee
        )                                                     AS total_surcharges
    FROM shipments
    GROUP BY DATE_TRUNC('month', CAST(ship_date AS DATE))
),
ranked_carriers AS (
    SELECT
        carrier_name,
        SUM(total_shipping_cost)                              AS carrier_total_cost,
        RANK() OVER (
            ORDER BY SUM(total_shipping_cost) DESC
        )                                                     AS carrier_cost_rank
    FROM shipments
    GROUP BY carrier_name
),
top_surcharge_lanes AS (
    SELECT
        origin_region,
        destination_zone,
        SUM(
            residential_fee
            + delivery_area_fee
            + oversized_fee
            + address_correction_fee
            + ltl_handling_fee
        )                                                     AS lane_non_fuel_surcharge_total,
        RANK() OVER (
            ORDER BY SUM(
                residential_fee
                + delivery_area_fee
                + oversized_fee
                + address_correction_fee
                + ltl_handling_fee
            ) DESC
        )                                                     AS lane_surcharge_rank
    FROM shipments
    GROUP BY
        origin_region,
        destination_zone
)
SELECT
    mc.ship_month,
    mc.total_shipments,
    mc.total_shipping_cost,
    ROUND(mc.total_shipping_cost / NULLIF(mc.total_shipments, 0), 2)     AS cost_per_shipment,
    ROUND(mc.total_shipping_cost / NULLIF(mc.total_billed_weight_lb, 0), 2) AS cost_per_billed_lb,
    ROUND(mc.total_surcharges * 100.0 / NULLIF(mc.total_shipping_cost, 0), 2) AS surcharge_pct_of_cost,
    LAG(mc.total_shipping_cost) OVER (ORDER BY mc.ship_month)             AS previous_month_cost,
    ROUND(
        (
            mc.total_shipping_cost
            - LAG(mc.total_shipping_cost) OVER (ORDER BY mc.ship_month)
        ) * 100.0
        / NULLIF(LAG(mc.total_shipping_cost) OVER (ORDER BY mc.ship_month), 0),
        2
    )                                                                     AS month_over_month_cost_pct_change
FROM monthly_costs AS mc
ORDER BY mc.ship_month;

/*
Supplemental views for executive storytelling:
1. Top cost carriers:
   SELECT * FROM ranked_carriers WHERE carrier_cost_rank <= 3;

2. Highest non-fuel surcharge lanes:
   SELECT * FROM top_surcharge_lanes WHERE lane_surcharge_rank <= 10;
*/
