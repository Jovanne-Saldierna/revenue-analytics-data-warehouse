WITH base_orders AS (
    SELECT
        CAST(o.order_date AS DATE)                                 AS order_date,
        DATE_TRUNC('month', CAST(o.order_date AS DATE))            AS revenue_month,
        o.order_id,
        o.customer_id,
        o.channel,
        o.quantity,
        o.unit_price,
        (o.quantity * o.unit_price)                                AS order_revenue
    FROM orders AS o
),

customer_order_sequence AS (
    SELECT
        bo.*,
        ROW_NUMBER() OVER (
            PARTITION BY bo.customer_id
            ORDER BY bo.order_date
        )                                                          AS customer_order_number
    FROM base_orders AS bo
),

monthly_summary AS (
    SELECT
        revenue_month,
        COUNT(DISTINCT order_id)                                   AS total_orders,
        COUNT(DISTINCT customer_id)                                AS total_customers,
        COUNT(DISTINCT CASE
            WHEN customer_order_number = 1 THEN customer_id
        END)                                                       AS new_customers,
        COUNT(DISTINCT CASE
            WHEN customer_order_number > 1 THEN customer_id
        END)                                                       AS returning_customers,
        SUM(quantity)                                              AS total_units_sold,
        SUM(order_revenue)                                         AS total_revenue,
        ROUND(AVG(order_revenue), 2)                               AS avg_order_value
    FROM customer_order_sequence
    GROUP BY
        revenue_month
)

SELECT
    revenue_month,
    total_orders,
    total_customers,
    new_customers,
    returning_customers,
    total_units_sold,
    total_revenue,
    avg_order_value,
    LAG(total_revenue) OVER (
        ORDER BY revenue_month
    )                                                              AS previous_month_revenue,
    total_revenue
        - LAG(total_revenue) OVER (
            ORDER BY revenue_month
        )                                                          AS revenue_growth,
    ROUND(
        (
            total_revenue
            - LAG(total_revenue) OVER (ORDER BY revenue_month)
        ) * 100.0
        / NULLIF(LAG(total_revenue) OVER (ORDER BY revenue_month), 0),
        2
    )                                                              AS revenue_growth_pct
FROM monthly_summary
ORDER BY
    revenue_month;
