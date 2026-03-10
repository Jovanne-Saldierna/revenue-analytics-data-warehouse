WITH shipment_rate_lookup AS (
    SELECT
        s.shipment_id,
        CAST(s.ship_date AS DATE)                           AS ship_date,
        s.carrier_id,
        s.carrier_name,
        s.service_level,
        s.destination_zone,
        s.billed_weight_lb,
        s.total_shipping_cost,
        rc.base_rate_per_lb,
        pr.proposed_rate_per_lb,
        (
            s.residential_fee
            + s.delivery_area_fee
            + s.oversized_fee
            + s.address_correction_fee
            + s.ltl_handling_fee
        )                                                   AS non_fuel_surcharges
    FROM shipments AS s
    INNER JOIN rate_cards AS rc
        ON s.carrier_id = rc.carrier_id
        AND s.service_level = rc.service_level
        AND s.destination_zone = rc.zone
        AND s.billed_weight_lb >= rc.min_weight_lb
        AND s.billed_weight_lb < rc.max_weight_lb
    INNER JOIN proposed_rates AS pr
        ON rc.carrier_id = pr.carrier_id
        AND rc.service_level = pr.service_level
        AND rc.zone = pr.zone
        AND rc.min_weight_lb = pr.min_weight_lb
        AND rc.max_weight_lb = pr.max_weight_lb
),
scenario_model AS (
    SELECT
        shipment_id,
        ship_date,
        carrier_name,
        service_level,
        destination_zone,
        billed_weight_lb,
        total_shipping_cost                                   AS actual_total_cost,
        ROUND(
            (billed_weight_lb * base_rate_per_lb)
            + non_fuel_surcharges,
            2
        )                                                     AS recalculated_current_cost_ex_fuel,
        ROUND(
            (billed_weight_lb * proposed_rate_per_lb)
            + non_fuel_surcharges,
            2
        )                                                     AS projected_cost_under_proposed_rate
    FROM shipment_rate_lookup
)
SELECT
    carrier_name,
    service_level,
    destination_zone,
    COUNT(*)                                                  AS shipment_count,
    SUM(actual_total_cost)                                    AS actual_total_cost,
    SUM(projected_cost_under_proposed_rate)                   AS projected_total_cost,
    ROUND(
        SUM(actual_total_cost) - SUM(projected_cost_under_proposed_rate),
        2
    )                                                         AS projected_savings,
    ROUND(
        (
            SUM(actual_total_cost) - SUM(projected_cost_under_proposed_rate)
        ) * 100.0 / NULLIF(SUM(actual_total_cost), 0),
        2
    )                                                         AS projected_savings_pct
FROM scenario_model
GROUP BY
    carrier_name,
    service_level,
    destination_zone
ORDER BY projected_savings DESC, carrier_name, service_level, destination_zone;
