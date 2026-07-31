select 
    id AS organizations_id,
    NAME AS organization_name,
    ADDRESS AS address,
    CITY AS city,
    STATE AS state,
    ZIP AS zip,
    LAT AS latitude,
    LON AS longitude
from {{ source('dbt_sidowu', 'organizations') }}