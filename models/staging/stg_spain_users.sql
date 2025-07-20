{{ config(materialized='view') }}

SELECT
    id,
    first_name,
    last_name,
    country
FROM {{ source('ecommerce', 'users') }}
WHERE country = 'Spain'