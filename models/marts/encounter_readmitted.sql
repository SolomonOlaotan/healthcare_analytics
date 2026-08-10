WITH readmission AS (
    select * from {{ ref("encounter_fct") }}

)
select
    encounter_id,
    patient_id,
    min(start_time) AS first_encounter_date,
    ROW_NUMBER() OVER (PARTITION BY patient_id ORDER BY start_time asc) AS encounter_date
from readmission
WHERE encounter_duration_minutes >= 43200
GROUP BY encounter_id, patient_id, start_time
