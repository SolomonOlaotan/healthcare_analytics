-- This is procedures fact table.
select
    procedure_id,
    patient_id,
    encounter_id,
    format_timestamp('%T', start_time) As start_time,
    format_timestamp('%T', stop_time) AS stop_time,
    procedure_duration_minutes,
    procedure_year,
    procedure_month,
    procedure_code,
    procedure_category,
    procedure_description,
    base_cost,
    CASE
        WHEN base_cost > 5000 THEN true 
        ELSE false
    END AS is_procedure_cost_high,
    reason_code,
    reason_description,
    has_reason,
    encounterType,
    total_cost

    from {{ ref("procedures_modified") }}