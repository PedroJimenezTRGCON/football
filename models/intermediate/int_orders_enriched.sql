{{ config(materialized='table') }}

WITH order_items_agg AS (
  SELECT
    order_id,
    COUNT(*) AS total_items,
    SUM(sale_price) AS total_amount,
    COUNTIF(status = 'returned') AS returned_items
  FROM {{ ref('stg_order_items') }}
  GROUP BY order_id
),

orders_base AS (
  SELECT
    order_id,
    user_id,
    status,
    created_at,
    shipped_at,
    delivered_at,
    returned_at,
    num_of_item
  FROM {{ ref('stg_orders') }}
  WHERE status NOT IN ('cancelled', 'failed')  -- filtramos órdenes inválidas
)

SELECT
  o.order_id,
  o.user_id,
  o.status,
  o.created_at,
  o.shipped_at,
  o.delivered_at,
  o.returned_at,
  COALESCE(o.num_of_item, 0) AS num_of_item,
  COALESCE(oi.total_items, 0) AS total_items,
  COALESCE(oi.total_amount, 0) AS total_amount,
  COALESCE(oi.returned_items, 0) AS returned_items,
  CASE
    WHEN o.returned_at IS NOT NULL THEN TRUE
    ELSE FALSE
  END AS is_returned,
  CASE
    WHEN o.delivered_at IS NOT NULL THEN TRUE
    ELSE FALSE
  END AS is_delivered

FROM orders_base o
LEFT JOIN order_items_agg oi ON o.order_id = oi.order_id
