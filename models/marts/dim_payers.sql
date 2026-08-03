-- This table define who's the payer and clasifies them

WITH payers AS (
    select * FROM {{ ref("stg_payers") }}
)

select
    payer_id,
    payer_name,
    CASE
        WHEN lower(payer_name) like '%medicare%'
        or lower(payer_name) like '%medicaid%'
        or lower(payer_name) like '%dual eligible%' THEN 'Government'
        ELSE 'private'
    END AS payer_type,
    CASE
         WHEN lower(payer_name) like '%medicare%'
        or lower(payer_name) like '%medicaid%'
        or lower(payer_name) like '%dual eligible%' THEN true
        ELSE false
    END AS is_government_payer,
    address,
    city,
    state_hq,
    zip_code,
    phone
    from payers 