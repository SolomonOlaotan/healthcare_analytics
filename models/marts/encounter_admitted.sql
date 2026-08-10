WITH encounter_admitted as (
    select * from {{ ref("encounter_fct") }}

)
select
    encounter_id,
    count(distinct patient_id) AS patient_id,
    patient_age,
    patient_race,
    patient_ethnicity,
    patient_gender,
    encounter_description,
    encounter_day_of_week,
    encounter_year,
    encounter_month,
    encounterType,
    encounter_duration_minutes

from encounter_admitted
WHERE encounter_duration_minutes >= 1440
group by 1,3,4,5,6,7,8,9,10,11,12
order by encounter_duration_minutes DESC