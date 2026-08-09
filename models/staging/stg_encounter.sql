select 
    id AS encounter_id,
    safe_cast(start AS timestamp) AS start_time,
    safe_cast(stop as timestamp) AS stop_time,
    patient AS patient_id,
    organisation AS organisation_id,
    payer AS payer_id,
    encounterClass AS encounterType,
    code AS encounter_code,
    description AS encounter_description,
    base_encounter_cost AS base_cost,
    total_claim_cost AS total_cost,
    payer_coverage,
    reasonCode AS reason_code,
    reasonDescription
from {{ source('dbt_sidowu', 'encounter') }}
