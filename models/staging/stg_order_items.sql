{{ config(materialized='view') }}

SELECT
  id AS order_item_id,
  order_id,
  user_id,
  product_id,
  inventory_item_id,
  LOWER(TRIM(status)) AS status,
  TIMESTAMP_TRUNC(created_at, SECOND) AS created_at,
  TIMESTAMP_TRUNC(shipped_at, SECOND) AS shipped_at,
  TIMESTAMP_TRUNC(delivered_at, SECOND) AS delivered_at,
  TIMESTAMP_TRUNC(returned_at, SECOND) AS returned_at,
  SAFE_CAST(sale_price AS FLOAT64) AS sale_price
FROM
  {{ source('ecommerce', 'order_items') }}
WHERE
  id IS NOT NULL AND order_id IS NOT NULL AND product_id IS NOT NULL
