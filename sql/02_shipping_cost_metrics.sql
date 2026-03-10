WITH monthly_shipping AS (
    SELECT
        DATE_TRUNC('month', CAST(ship_date AS DATE))      AS ship_month,
        COUNT(DISTINCT shipment_id)                       AS total_shipments,
        COUNT(DISTINCT order_id)                          AS total_orders_shipped,
        SUM(billed_weight_lb)                             AS total_billed_weight_lb,
        SUM(total_shipping_cost)                          AS total_shipping_cost,
        SUM(base_cost)                                    AS total_base_cost,
        SUM(fuel_surcharge)                               AS total_fuel_surcharge,
        SUM(
            residential_fee
            + delivery_area_fee
            + oversized_fee
            + address_correction_fee
            + ltl_handling_fee
        )                                                 AS total_non_fuel_surcharges
    FROM shipments
    GROUP BY DATE_TRUNC('month', CAST(ship_date AS DATE))
),
final AS (
    SELECT
        ship_month,
        total_shipments,
        total_orders_shipped,
        total_billed_weight_lb,
        total_shipping_cost,
        total_base_cost,
        total_fuel_surcharge,
        total_non_fuel_surcharges,
        ROUND(total_shipping_cost / NULLIF(total_shipments, 0), 2)     AS cost_per_shipment,
        ROUND(total_shipping_cost / NULLIF(total_billed_weight_lb, 0), 2) AS cost_per_billed_lb,
        LAG(total_shipping_cost) OVER (
            ORDER BY ship_month
        )                                                               AS previous_month_cost,
        total_shipping_cost
            - LAG(total_shipping_cost) OVER (
                ORDER BY ship_month
            )                                                           AS month_over_month_cost_change
    FROM monthly_shipping
)
SELECT
    ship_month,
    total_shipments,
    total_orders_shipped,
    total_billed_weight_lb,
    total_shipping_cost,
    total_base_cost,
    total_fuel_surcharge,
    total_non_fuel_surcharges,
    cost_per_shipment,
    cost_per_billed_lb,
    previous_month_cost,
    month_over_month_cost_change
FROM final
ORDER BY ship_month;
