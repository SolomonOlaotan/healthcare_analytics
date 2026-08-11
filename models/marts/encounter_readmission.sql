-- This table filters readmitted patients 
WITH encounter  AS (
    select * from {{ ref("encounter_modified") }}

),
-- rank patient's encounter by date
encounter_ranked AS (
select
    encounter_id,
    patient_id,
    payer_id,
    payer_name,
    start_time, stop_time,
    encounter_duration_minutes,
    encounter_year,
    encounter_month,
    encounter_day_of_week,
    encounterType,
    encounter_description,
    total_cost,
    out_of_pocket_cost,
    payer_coverage_rate,
    patient_gender,
    patient_race,
    patient_ethnicity,
    patient_age,
    -- compute for the previous end date for the same patient
    LAG(stop_time) OVER (PARTITION BY patient_id ORDER BY start_time) AS previous_encounter_stop,
    -- rank the encounters per patient according to date
    ROW_NUMBER() OVER (PARTITION BY patient_id ORDER BY start_time) AS encounter_number
from encounter
WHERE encounter_duration_minutes >= 1440 -- admitted patients only
),
readmission AS (
    select *,   
        DATE_DIFF(
            CAST(start_time AS DATE), CAST(previous_encounter_stop AS DATE), DAY
        ) AS days_since_last_encounter,
        CASE 
            WHEN DATE_DIFF(
                CAST(start_time AS DATE), CAST(previous_encounter_stop AS DATE), DAY
            ) <= 30 THEN true
            ELSE false
        END AS is_admitted_30_days
    from encounter_ranked
    WHERE encounter_number > 1

)
select
    encounter_id,
    patient_id,
    payer_id,
    payer_name,
    start_time,
    stop_time,
    previous_encounter_stop,
    days_since_last_encounter,
    is_admitted_30_days,
    encounter_number,
    encounter_duration_minutes,
    encounter_year,
    encounter_month,
    encounter_day_of_week,
    encounterType,
    encounter_description,
    total_cost,
    out_of_pocket_cost,
    payer_coverage_rate,
    patient_gender,
    patient_race,
    patient_ethnicity,
    patient_age

from readmission
ORDER BY patient_id, start_time
