select 
    -- procedures has no surrogate id in the source, so generate one
        {{ dbt_utils.generate_surrogate_key(['PATIENT', 'ENCOUNTER', 'CODE', 'START']) }} as procedure_id,
        START AS start_time,
        STOP AS stop_time,
        PATIENT AS patient_id,
        ENCOUNTER AS encounter_id,
        CODE AS procedure_code,
        DESCRIPTION AS procedure_description,
        BASE_COST AS base_cost,
        REASONCODE AS reason_code,
        REASONDESCRIPTION AS reason_description
from {{ source('dbt_sidowu', 'procedures')}}