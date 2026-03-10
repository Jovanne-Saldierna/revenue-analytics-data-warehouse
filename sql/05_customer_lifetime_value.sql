WITH customer_revenue AS (
    SELECT
        o.customer_id,
        MIN(CAST(o.order_date AS DATE))                            AS first_order_date,
        MAX(CAST(o.order_date AS DATE))                            AS most_recent_order_date,
        COUNT(DISTINCT o.order_id)                                 AS total_orders,
        SUM(o.quantity * o.unit_price)                             AS lifetime_revenue
    FROM orders AS o
    GROUP BY
        o.customer_id
),

final AS (
    SELECT
        cr.customer_id,
        c.customer_name,
        c.region,
        cr.first_order_date,
        cr.most_recent_order_date,
        cr.total_orders,
        cr.lifetime_revenue,
        ROUND(
            cr.lifetime_revenue / NULLIF(cr.total_orders, 0),
            2
        )                                                          AS avg_revenue_per_order,
        DENSE_RANK() OVER (
            ORDER BY cr.lifetime_revenue DESC
        )                                                          AS customer_value_rank
    FROM customer_revenue AS cr
    INNER JOIN customers AS c
        ON cr.customer_id = c.customer_id
)

SELECT
    customer_id,
    customer_name,
    region,
    first_order_date,
    most_recent_order_date,
    total_orders,
    lifetime_revenue,
    avg_revenue_per_order,
    customer_value_rank
FROM final
ORDER BY
    customer_value_rank;
