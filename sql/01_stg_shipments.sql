SELECT
    s.shipment_id,
    CAST(s.ship_date AS DATE)                              AS ship_date,
    s.order_id,
    s.carrier_id,
    s.carrier_name,
    s.service_level,
    s.origin_region,
    s.destination_zone,
    s.package_weight_lb,
    s.package_length_in,
    s.package_width_in,
    s.package_height_in,
    s.billed_weight_lb,
    s.base_cost,
    s.fuel_surcharge,
    s.residential_fee,
    s.delivery_area_fee,
    s.oversized_fee,
    s.address_correction_fee,
    s.ltl_handling_fee,
    s.total_shipping_cost,
    s.delivered_days,
    (
        s.residential_fee
        + s.delivery_area_fee
        + s.oversized_fee
        + s.address_correction_fee
        + s.ltl_handling_fee
    )                                                     AS non_fuel_surcharge_total,
    ROUND(
        s.total_shipping_cost / NULLIF(s.billed_weight_lb, 0),
        2
    )                                                     AS cost_per_billed_lb,
    ROUND(
        s.package_length_in * s.package_width_in * s.package_height_in / 139.0,
        2
    )                                                     AS dimensional_weight_lb,
    CASE
        WHEN s.billed_weight_lb > s.package_weight_lb THEN 1
        ELSE 0
    END                                                   AS billed_above_actual_flag
FROM shipments AS s;
