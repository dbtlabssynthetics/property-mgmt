-- This approach to x-proj referencing is somewhat misleading, as it’s actually referencing a model within the same project.
select * from {{ ref('dbt_property_mgmt', 'stg_properties.v2') }}
