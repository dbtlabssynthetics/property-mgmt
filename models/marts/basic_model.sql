WITH
-- First source table
source_1 AS (
    SELECT
        id,
        name,
        created_at
    FROM {{ ref('raw_table_1') }}
),

-- Second source table
source_2 AS (
    SELECT
        id,
        name,
        created_at
    FROM {{ ref('raw_table_2') }}
),

-- Union the two source tables
unioned_sources AS (
    SELECT * FROM source_1
    UNION ALL
    SELECT * FROM source_2
),

-- Another table to join on
join_table AS (
    SELECT
        id,
        additional_info
    FROM {{ ref('raw_table_3') }}
)

-- Final result with a JOIN, filter, and aggregation
SELECT
    u.id,
    u.name,
    COUNT(u.id) AS total_count,  -- Aggregation example
    MAX(u.created_at) AS latest_created_at,  -- Example of another aggregate
    j.additional_info
FROM unioned_sources u
LEFT JOIN join_table j
ON u.id = j.id
-- Apply a filter (e.g., filtering by recent data)
WHERE u.created_at >= '2023-01-01'
-- Grouping the result for the aggregation
GROUP BY
    u.id,
    u.name,
    j.additional_info
-- Order by the most recent created_at
ORDER BY latest_created_at DESC