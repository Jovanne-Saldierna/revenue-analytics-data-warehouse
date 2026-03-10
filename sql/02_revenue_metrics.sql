WITH stg_orders AS (
    SELECT
         o.order_id
        ,CAST(o.order_date AS DATE) AS order_date
        ,o.customer_id
        ,o.product_id
        ,o.channel
        ,o.quantity
        ,o.unit_price
        ,(o.quantity * o.unit_price) AS order_revenue
    FROM orders o
),

monthly_revenue AS (
    SELECT
         DATE_TRUNC('month', order_date) AS revenue_month
        ,COUNT(DISTINCT order_id) AS total_orders
        ,COUNT(DISTINCT customer_id) AS total_customers
        ,SUM(order_revenue) AS total_revenue
        ,AVG(order_revenue) AS avg_order_value
    FROM stg_orders
    GROUP BY DATE_TRUNC('month', order_date)
)

SELECT
     revenue_month
    ,total_orders
    ,total_customers
    ,total_revenue
    ,avg_order_value
    ,LAG(total_revenue) OVER (ORDER BY revenue_month) AS previous_month_revenue
    ,total_revenue -
     LAG(total_revenue) OVER (ORDER BY revenue_month) AS revenue_growth
FROM monthly_revenue
ORDER BY revenue_month;
