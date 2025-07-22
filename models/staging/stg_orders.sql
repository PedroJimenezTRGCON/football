{{ config(materialized='view') }}

SELECT
  order_id,
  user_id,
  LOWER(TRIM(status)) AS status,
  LOWER(TRIM(gender)) AS gender,
  TIMESTAMP_TRUNC(created_at, SECOND) AS created_at,
  TIMESTAMP_TRUNC(returned_at, SECOND) AS returned_at,
  TIMESTAMP_TRUNC(shipped_at, SECOND) AS shipped_at,
  TIMESTAMP_TRUNC(delivered_at, SECOND) AS delivered_at,
  SAFE_CAST(num_of_item AS INT64) AS num_of_item
FROM
  {{ source('ecommerce', 'orders') }}
WHERE
  order_id IS NOT NULL AND user_id IS NOT NULL