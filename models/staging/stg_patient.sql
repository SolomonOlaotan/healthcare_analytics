

select 
     id AS patient_id,
    Deathdate,
    prefix,
    first,
    last,
    suffix,
    maiden,
    marital,
    race,
    ethnicity,
    gender,
    birthplace,
    address,
    city,
    state,
    county,
    zip,
    lat,
    lon
   
from {{ source('dbt_sidowu', 'patient') }}