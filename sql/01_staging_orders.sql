SELECT
     o.order_id
    ,CAST(o.order_date AS DATE) AS order_date
    ,o.customer_id
    ,o.product_id
    ,o.channel
    ,o.quantity
    ,o.unit_price
    ,(o.quantity * o.unit_price) AS order_revenue
FROM orders AS o;
