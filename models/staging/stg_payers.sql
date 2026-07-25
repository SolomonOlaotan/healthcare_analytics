select *
from {{ source('dbt_sidowu', 'payers')}}