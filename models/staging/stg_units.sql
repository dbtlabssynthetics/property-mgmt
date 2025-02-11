WITH source AS (
    SELECT * FROM {{ ref("raw_units_data") }}
),

cleaned AS (
    SELECT
        unit_id,
        property_id,
        TRIM(unit_number) AS unit_number, -- Remove spaces in unit numbers
        CAST(unit_size_sqft AS INTEGER) AS unit_size_sqft, -- Ensure correct type
        CAST(monthly_rent AS DECIMAL(12,2)) AS monthly_rent -- Ensure precision for financials
    FROM source
)

SELECT * FROM cleaned
