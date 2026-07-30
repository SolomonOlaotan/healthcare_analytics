

select 
    id AS patient_id,
    Birthdate AS birth_date,
    Deathdate AS death_date,
    trim(prefix) AS name_prefix,
    trim(first) AS first_name,
    trim(last) AS last_name,
    trim(suffix) AS name_sufix,
    trim(maiden) AS maiden_name,
    CASE marital
        WHEN 'M' THEN 'Married'
        WHEN 'S' THEN 'Single'
        WHEN 'D' THEN 'Divorced'
        WHEN 'W' THEN 'Widowed'
        else 'Unknown'
    END AS marital_status,
    race,
    ethnicity,
    CASE gender
        WHEN 'M' THEN 'Male'
        WHEN '' THEN 'Female'
    END AS gender,
    birthplace,
    address,
    city,
    state,
    county,
    zip AS zip_code,
    lat AS latitude,
    lon AS longitude
   
from {{ source('dbt_sidowu', 'patient') }}