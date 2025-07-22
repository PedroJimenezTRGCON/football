{{ config(materialized='table') }}

SELECT
  user_id,
  first_name,
  last_name,
  email,
  age,
  gender,
  state,
  city,
  country,
  created_at,
  traffic_source
FROM {{ ref('stg_users') }}
WHERE user_id IS NOT NULL
