{{ config(materialized='table') }}

WITH orders_summary AS (
  SELECT
    user_id,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT CASE WHEN status = 'delivered' THEN order_id END) AS delivered_orders,
    COUNT(DISTINCT CASE WHEN status = 'returned' THEN order_id END) AS returned_orders,
    SUM(num_of_item) AS total_items_ordered
  FROM {{ ref('stg_orders') }}
  GROUP BY user_id
),

spend_summary AS (
  SELECT
    user_id,
    SUM(sale_price) AS total_spent
  FROM {{ ref('stg_order_items') }}
  GROUP BY user_id
)

SELECT
  u.user_id,
  u.first_name,
  u.last_name,
  u.email,
  COALESCE(os.total_orders, 0) AS total_orders,
  COALESCE(os.delivered_orders, 0) AS delivered_orders,
  COALESCE(os.returned_orders, 0) AS returned_orders,
  COALESCE(os.total_items_ordered, 0) AS total_items_ordered,
  COALESCE(ss.total_spent, 0) AS total_spent

FROM {{ ref('stg_users') }} u
LEFT JOIN orders_summary os ON u.user_id = os.user_id
LEFT JOIN spend_summary ss ON u.user_id = ss.user_id
