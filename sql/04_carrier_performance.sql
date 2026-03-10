WITH carrier_summary AS (
    SELECT
        carrier_name,
        service_level,
        COUNT(*)                                            AS shipment_count,
        SUM(billed_weight_lb)                               AS total_billed_weight_lb,
        SUM(total_shipping_cost)                            AS total_shipping_cost,
        ROUND(AVG(total_shipping_cost), 2)                  AS avg_cost_per_shipment,
        ROUND(
            SUM(total_shipping_cost) / NULLIF(SUM(billed_weight_lb), 0),
            2
        )                                                   AS avg_cost_per_billed_lb,
        ROUND(AVG(delivered_days), 2)                       AS avg_transit_days,
        ROUND(
            AVG(
                CASE
                    WHEN billed_weight_lb > package_weight_lb THEN 1.0
                    ELSE 0.0
                END
            ) * 100,
            2
        )                                                   AS pct_billed_above_actual
    FROM shipments
    GROUP BY
        carrier_name,
        service_level
)
SELECT
    carrier_name,
    service_level,
    shipment_count,
    total_billed_weight_lb,
    total_shipping_cost,
    avg_cost_per_shipment,
    avg_cost_per_billed_lb,
    avg_transit_days,
    pct_billed_above_actual,
    DENSE_RANK() OVER (
        ORDER BY avg_cost_per_billed_lb ASC
    )                                                       AS cost_efficiency_rank
FROM carrier_summary
ORDER BY cost_efficiency_rank, carrier_name, service_level;
