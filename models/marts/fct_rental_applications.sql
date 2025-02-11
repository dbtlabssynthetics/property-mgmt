WITH applications AS (
    SELECT * FROM {{ ref('stg_rental_apps') }}
),

aggregated AS (
    SELECT
        property_id,
        COUNT(application_id) AS total_applications,
        COUNT(CASE WHEN application_status = 'approved' THEN 1 END) AS approved_applications,
        COUNT(CASE WHEN application_status = 'rejected' THEN 1 END) AS rejected_applications,
        COUNT(CASE WHEN application_status = 'pending' THEN 1 END) AS pending_applications,
        ROUND(
            COUNT(CASE WHEN application_status = 'approved' THEN 1 END) * 100.0 / NULLIF(COUNT(application_id), 0), 2
        ) AS approval_rate -- Avoid division by zero
    FROM applications
    GROUP BY property_id
)

SELECT * FROM aggregated
