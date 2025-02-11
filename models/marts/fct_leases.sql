WITH source AS (
    SELECT
        lease_id,
        property_id,
        tenant_id,
        lease_start_date,
        lease_end_date,
        monthly_rent
    FROM {{ ref('stg_leases') }}
),

calculated_fields AS (
    SELECT
        *,
        DATEDIFF(MONTH, lease_start_date, lease_end_date) AS lease_duration_months,
        -- Lease status: Active if the end date is in the future
        CASE 
            WHEN lease_end_date >= CURRENT_DATE THEN 'Active'
            ELSE 'Expired'
        END AS lease_status,
        -- Total lease value calculation
        monthly_rent * DATEDIFF(MONTH, lease_start_date, lease_end_date) AS total_lease_value
    FROM source
)

SELECT * FROM calculated_fields
