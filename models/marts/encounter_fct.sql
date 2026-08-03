-- This table creates a fact table from encounter modified.
select
    encounter_id,
    patient_id,
    payer_id,
    payer_name,
    organisation_id,
    format_timestamp('%T', start_time) As start_time,
    format_timestamp('%T', stop_time) AS stop_time,
    encounter_duration_minutes,
    encounter_year,
    encounter_month,
    encounter_day_of_week,
    encounterType,
    CASE
        WHEN encounter_duration_minutes <= 30 THEN 'short'
        WHEN encounter_duration_minutes <= 120 THEN 'medium'
        ELSE 'long'
    END AS encounter_length_category,
    encounter_code,
    encounter_description,
    base_cost,
    total_cost,
    payer_coverage,
    out_of_pocket_cost,
    payer_coverage_rate,
    is_fully_paid,
    CASE
        WHEN total_cost > 1000 THEN true
        ELSE false
    END AS is_encounter_cost_high,
    reason_code,
    reasonDescription,
    patient_gender,
    patient_race,
    patient_ethnicity,
    patient_age

    from {{ ref("encounter_modified") }}