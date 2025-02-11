WITH source AS (
    SELECT * FROM {{ ref("raw_rental_apps_data") }}
),

cleaned AS (
    SELECT
        application_id,
        tenant_id,
        property_id,
        CAST(application_date AS DATE) AS application_date, -- Ensure correct date type
        LOWER(TRIM(status)) AS application_status -- Normalize status values
    FROM source
)

SELECT * FROM cleaned
