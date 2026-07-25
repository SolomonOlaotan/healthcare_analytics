select 
    id AS encounter_id,
    start,
    stop,
    patient AS patient_id,
    organisation,
    payer AS payer_id,
    encounterClass AS encounterType,
    code,
    description,
    base_encounter_cost AS base_cost,
    total_claim_cost AS total_cost,
    payer_coverage,
    reasonCode,
    reasonDescription
from {{ source('dbt_sidowu', 'encounter') }}
