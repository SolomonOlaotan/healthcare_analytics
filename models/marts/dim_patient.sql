-- This table creates dim_patient
--derives some calculated attributes 
WITH patient AS (
    select * from {{ ref('stg_patient') }}
)

select
    patient_id,
    TRIM(CONCAT(COALESCE(name_prefix || ' ', ''), COALESCE(first_name || ' ', ''), COALESCE(last_name || ' ', ''), COALESCE(name_sufix, ''))) AS full_name,
    gender,
    race, 
    ethnicity,
    marital_status,
    birth_date,
    death_date,
    CASE
        WHEN death_date IS NOT NULL THEN true
        ELSE false
    END AS is_deceased,
    CASE
        WHEN death_date IS NOT NULL THEN date_diff(death_date, birth_date, year)
        ELSE date_diff(current_date, birth_date, year)
    END AS age,
    CASE
        WHEN date_diff(current_date, birth_date, year) <= 18 THEN '0-18'
        WHEN date_diff(current_date, birth_date, year) <= 35 THEN '19-35' 
        WHEN date_diff(current_date, birth_date, year) <= 55 THEN '35-55'
        WHEN date_diff(current_date, birth_date, year) <= 75 THEN '55-75'
        ELSE '75 Plus'
    END AS age_band,
    birthplace,
    address,
    city,
    state,
    county,
    zip_code,
    latitude,
    longitude

    from patient