select *
from {{ source('dbt_sidowu', 'procedures')}}