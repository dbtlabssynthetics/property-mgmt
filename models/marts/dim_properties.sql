WITH properties AS (
    SELECT
        property_id,
        property_name,
        address,
        num_units
    FROM {{ ref('stg_properties') }}
),

units AS (
    SELECT
        property_id,
        monthly_rent
    FROM {{ ref('stg_units') }}
),

aggregated_rents AS (
    SELECT
        property_id,
        AVG(monthly_rent) AS avg_rent
    FROM units
    GROUP BY property_id
),

rental_applications AS (
    SELECT
        property_id,
        total_applications,
        approved_applications,
        rejected_applications,
        pending_applications,
        approval_rate
    FROM {{ ref('fct_rental_applications') }}
)

SELECT
    p.property_id,
    p.property_name,
    p.address,
    p.num_units,
    COALESCE(ar.avg_rent, 0) AS avg_rent, -- Default to 0 if no rent data available

    -- Calculate occupancy rate: number of units with rent vs total units
    CASE 
        WHEN p.num_units > 0 THEN 
            (COUNT(u.property_id) * 1.0 / p.num_units) * 100
        ELSE 0 
    END AS occupancy_rate,

    -- Rental application insights
    COALESCE(ra.total_applications, 0) AS total_applications,
    COALESCE(ra.approved_applications, 0) AS approved_applications,
    COALESCE(ra.rejected_applications, 0) AS rejected_applications,
    COALESCE(ra.pending_applications, 0) AS pending_applications,
    COALESCE(ra.approval_rate, 0) AS approval_rate

FROM properties AS p
LEFT JOIN aggregated_rents AS ar 
    ON p.property_id = ar.property_id
LEFT JOIN units AS u 
    ON p.property_id = u.property_id
LEFT JOIN rental_applications AS ra 
    ON p.property_id = ra.property_id
GROUP BY 
    p.property_id, 
    p.property_name, 
    p.address, 
    p.num_units, 
    ar.avg_rent, 
    ra.total_applications, 
    ra.approved_applications, 
    ra.rejected_applications, 
    ra.pending_applications, 
    ra.approval_rate
