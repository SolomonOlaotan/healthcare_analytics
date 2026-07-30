select 
    id AS payer_id,
    NAME AS payer_name,
    ADDRESS AS address,
    CITY AS city,
    STATE_HEADQUARTERED AS state_hq,
    ZIP AS zip_code,
    PHONE AS phone
from {{ source('dbt_sidowu', 'payers')}}