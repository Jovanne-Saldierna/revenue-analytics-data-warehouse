WITH shipment_surcharges AS (
    SELECT
        shipment_id,
        carrier_name,
        service_level,
        destination_zone,
        total_shipping_cost,
        fuel_surcharge,
        residential_fee,
        delivery_area_fee,
        oversized_fee,
        address_correction_fee,
        ltl_handling_fee,
        (
            fuel_surcharge
            + residential_fee
            + delivery_area_fee
            + oversized_fee
            + address_correction_fee
            + ltl_handling_fee
        )                                                   AS total_surcharge_amount
    FROM shipments
),
final AS (
    SELECT
        carrier_name,
        service_level,
        destination_zone,
        COUNT(*)                                            AS shipment_count,
        SUM(total_shipping_cost)                            AS total_shipping_cost,
        SUM(total_surcharge_amount)                         AS total_surcharge_amount,
        ROUND(AVG(total_surcharge_amount), 2)               AS avg_surcharge_per_shipment,
        ROUND(
            SUM(total_surcharge_amount) * 100.0
            / NULLIF(SUM(total_shipping_cost), 0),
            2
        )                                                   AS surcharge_pct_of_total_cost
    FROM shipment_surcharges
    GROUP BY
        carrier_name,
        service_level,
        destination_zone
)
SELECT
    carrier_name,
    service_level,
    destination_zone,
    shipment_count,
    total_shipping_cost,
    total_surcharge_amount,
    avg_surcharge_per_shipment,
    surcharge_pct_of_total_cost,
    RANK() OVER (
        ORDER BY total_surcharge_amount DESC
    )                                                       AS surcharge_burden_rank
FROM final
ORDER BY surcharge_burden_rank, carrier_name, service_level, destination_zone;
