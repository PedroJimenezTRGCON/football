{{ config(materialized='table') }}

WITH orders_with_items AS (
  SELECT
    o.order_id,
    o.user_id,
    DATE(o.created_at) AS order_date,
    oi.product_id,
    oi.sale_price
  FROM {{ ref('stg_orders') }} o
  JOIN {{ ref('stg_order_items') }} oi ON o.order_id = oi.order_id
  WHERE o.status = 'complete'
)

SELECT
  user_id,
  order_date,
  COUNT(DISTINCT order_id) AS orders_count,
  COUNT(product_id) AS items_sold,
  SUM(sale_price) AS total_revenue,
  ARRAY_AGG(DISTINCT order_id) AS order_ids
FROM orders_with_items
GROUP BY user_id, order_date

