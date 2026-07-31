--This query adds calculated and derived field, joins patien/payer to enounter table

WITH encounter as(

    select * from {{ ref("stg_encounter") }}
),
patient as (
    select * from {{ ref("stg_patient") }}
),
--payers as (
    --select * from {{ ref("stg_payers") }}
--),

encounter_modified as (
    select
        e.encounter_id,
        e.patient_id,
        e.payer_id,
        e.organisation,
        e.start,
        e.stop,
        timestamp_diff(e.stop, e.start, minute) AS encounter_duration_minutes,
        extract(year from e.start) AS encounter_year,
        extract(month from e.start) AS encounter_month,
        format_timestamp('%A', e.start) AS encounter_day_of_week,
        e.encounterType,
        e.code,
        e.reasonDescription,
        e.base_cost,
        e.total_cost,
        e.payer_coverage,
        round(e.total_cost - e.payer_coverage, 2) AS out_of_pocket_cost,
        CASE
            WHEN e.total_cost > 0 THEN round(e.payer_coverage/e.total_cost, 4)
            ELSE null
        END  AS payer_coverage_rate,
        CASE
            WHEN e.payer_coverage>=e.total_cost THEN true
            ELSE false
        END AS is_fully_paid,
    --patient attributes
    p.gender AS patient_gender,
    p.race AS patient_race,
    p.ethnicity AS patient_ethnicity,
    --date_diff(current_date(), p.birth_date, year) AS patient_age,
    --payer attributes
    --y.payer_name

    from encounter e 
    LEFT JOIN patient p ON e.patient_id = p.patient_id
    --LEFT JOIN payers y ON e.payer_id = y.id

)

select * from encounter_modified