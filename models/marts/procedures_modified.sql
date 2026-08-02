--This query modifies procedures table
--merges procedures and encounter tables
--derives some calculated attributes
WITH procedures As (
    select * from {{ ref('stg_procedures') }}
),
encounter AS (
    select * from{{ ref('stg_encounter') }}
),

procedures_modified AS (
    select
        pr.procedure_id,
        pr.patient_id,
        pr.encounter_id,
        pr.start_time,
        pr.stop_time,
        timestamp_diff(pr.stop_time, pr.start_time, MINUTE) AS procedure_duration_minutes,
        extract(year from pr.start_time) AS procedure_year,
        format_timestamp('%b', pr.start_time) AS procedure_month,
        pr.procedure_code,
        pr.procedure_description,
        pr.base_cost,
        pr.reason_code,
        pr.reason_description,
        CASE
            WHEN pr.reason_code IS NOT NULL THEN true
            ELSE false
        END AS has_reason,
        -- categorisation of clinical examinations
        CASE
            WHEN lower(pr.procedure_description) like '%dialysis%' THEN 'Renal'
            WHEN lower(pr.procedure_description) like '%chemotherapy%'
            or lower(pr.procedure_description) like '%radiation%'
            or lower(pr.procedure_description) like '%biopsy%'  THEN 'Oncology'
            WHEN lower(pr.procedure_description) like '%injection%'
            or lower(pr.procedure_description) like '%immunization%' THEN 'Immunisation'
            WHEN lower(pr.procedure_description) like '%cardiac%' 
            or lower(pr.procedure_description) like '%heart%' THEN 'Cardiology'
            WHEN lower(pr.procedure_description) like '%cardioversion%' THEN 'Atrial Fibrillation'
            WHEN lower(pr.procedure_description) like '%hospice%' 
            or lower(pr.procedure_description) like '%social care%' THEN 'Care Home'
            WHEN lower(pr.procedure_description) like '%respiratory%' THEN 'Acute Bronchitis'
            WHEN lower(pr.procedure_description) like '%abuse%' THEN 'Domestic Issues'
            WHEN lower(pr.procedure_description) like '%glucose%'
            or lower(pr.procedure_description) like '%diabetes'  THEN 'Diabetes'
            ELSE 'Other'
        END AS procedure_category,
    --encounter attributes
        e.encounterType,
        e.total_cost
    from 
        procedures pr
    LEFT JOIN encounter e 
    ON pr.encounter_id = e.encounter_id

)
select *
from procedures_modified