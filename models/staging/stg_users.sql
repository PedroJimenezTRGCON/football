{{ config(materialized='view') }}

SELECT
  id AS user_id,
  SAFE_CAST(first_name AS STRING) AS first_name,
  SAFE_CAST(last_name AS STRING) AS last_name,
  SAFE_CAST(email AS STRING) AS email,
  SAFE_CAST(age AS INT64) AS age,
  LOWER(TRIM(gender)) AS gender,
  SAFE_CAST(state AS STRING) AS state,
  SAFE_CAST(street_address AS STRING) AS street_address,
  SAFE_CAST(postal_code AS STRING) AS postal_code,
  SAFE_CAST(city AS STRING) AS city,
  SAFE_CAST(country AS STRING) AS country,
  SAFE_CAST(latitude AS FLOAT64) AS latitude,
  SAFE_CAST(longitude AS FLOAT64) AS longitude,
  LOWER(TRIM(traffic_source)) AS traffic_source,
  TIMESTAMP_TRUNC(created_at, SECOND) AS created_at,
  IF(user_geom IS NULL AND longitude IS NOT NULL AND latitude IS NOT NULL,
     ST_GEOGPOINT(longitude, latitude),
     user_geom) AS user_geom
FROM
  {{ source('ecommerce', 'users') }}
WHERE
  id IS NOT NULL
