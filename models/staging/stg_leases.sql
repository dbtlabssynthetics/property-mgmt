WITH source AS (
    SELECT 
        * 
    FROM {{ ref('raw_lease_data') }}
),

cleaned AS (
    SELECT
        lease_id,
        property_id,
        tenant_id,
        CAST(lease_start_date AS DATE) AS lease_start_date, -- Ensure correct data type
        CAST(lease_end_date AS DATE) AS lease_end_date,
        CAST(monthly_rent AS DECIMAL(12,2)) AS monthly_rent -- Ensure precision for financial data
    FROM source
)

SELECT * FROM cleaned
