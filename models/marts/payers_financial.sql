-- This table aggregate financial KPI of the payers

WITH encounter AS (
    select * from {{ ref("encounter_fct") }}
)
select
    payer_id,
    payer_name,
    count(distinct encounter_id) AS number_encounter,
    count(distinct patient_id) AS patient_count,
    round(sum(total_cost), 2) AS total_claim_value,
    round(sum(payer_coverage), 2) AS total_payer_coverage,
    round(sum(out_of_pocket_cost), 2) AS total_out_of_pocket_cost,
    round(avg(payer_coverage_rate), 2) AS avg_payer_coverage,
    round(avg(total_cost), 2) AS avg_total_cost_value,
    sum(
        CASE
            WHEN is_encounter_cost_high THEN 1
            ELSE 0
        END) AS encounter_high_cost_count
    from encounter
    group by 
    payer_id, payer_name
    order by 
    total_claim_value DESC 