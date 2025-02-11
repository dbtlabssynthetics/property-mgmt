WITH source AS (
    SELECT * FROM {{ ref("raw_properties_data") }}
),

cleaned AS (
    SELECT
        property_id,
        TRIM(property_name) AS property_name, -- Remove leading/trailing spaces
        TRIM(address) AS address,
        CAST(num_units AS INTEGER) AS num_units -- Ensure correct data type
    FROM source
)

SELECT * FROM cleaned
