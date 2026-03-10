WITH lane_summary AS (
    SELECT
        origin_region,
        destination_zone,
        carrier_name,
        COUNT(*)                                            AS shipment_count,
        SUM(billed_weight_lb)                               AS total_billed_weight_lb,
        SUM(total_shipping_cost)                            AS total_shipping_cost,
        ROUND(AVG(total_shipping_cost), 2)                  AS avg_cost_per_shipment,
        ROUND(
            SUM(total_shipping_cost) / NULLIF(SUM(billed_weight_lb), 0),
            2
        )                                                   AS avg_cost_per_billed_lb
    FROM shipments
    GROUP BY
        origin_region,
        destination_zone,
        carrier_name
)
SELECT
    origin_region,
    destination_zone,
    carrier_name,
    shipment_count,
    total_billed_weight_lb,
    total_shipping_cost,
    avg_cost_per_shipment,
    avg_cost_per_billed_lb,
    RANK() OVER (
        PARTITION BY origin_region, destination_zone
        ORDER BY avg_cost_per_billed_lb ASC
    )                                                       AS lane_cost_rank
FROM lane_summary
ORDER BY origin_region, destination_zone, lane_cost_rank;
