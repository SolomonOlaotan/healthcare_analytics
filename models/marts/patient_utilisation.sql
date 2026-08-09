-- This table ctreates patient hospital utilisation
-- from encounter and precedures tables

WITH encounter AS (
    select * from {{ ref("encounter_fct") }}
),
procedures AS (
    select * from {{ ref("procedures_fct") }}
),
encounter_agg AS (
    select
        patient_id,
        count(distinct encounter_id) AS number_encounter,
        round(sum(total_cost), 2) AS total_cost,
        round(sum(out_of_pocket_cost), 2) AS total_out_of_pocket_cost,
        min(start_time) AS first_encounter_date,
        max(start_time) AS last_encounter_date

    from encounter
        group by patient_id
),
procedures_agg AS (
    select  
        patient_id,
        count(distinct procedure_id) AS number_procedures,
        round(sum(base_cost), 2) AS total_procedure_cost

    from procedures
    group by patient_id
)

select
    d.patient_id,
    d.gender,
    d.age,
    d.age_band,
    coalesce(e.number_encounter, 0) AS number_encounter,
    coalesce(pr.number_procedures, 0) as number_procedures,
    coalesce(e.total_cost, 0) AS total_cost,
    coalesce(e.total_out_of_pocket_cost, 0) AS total_out_of_pocket_cost,
    coalesce(pr.total_procedure_cost, 0) AS total_procedure_cost,
    e.first_encounter_date,
    e.last_encounter_date
from {{ref("dim_patient") }} d 
LEFT JOIN encounter_agg e ON d.patient_id = e.patient_id
LEFT JOIN procedures_agg pr ON d.patient_id = pr.patient_id
--LEFT JOIN(select distinct patient_id from encounter) p d.patient_id = p.patient_id
