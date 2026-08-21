--This query modifies procedures table
--merges procedures and encounter tables
--derives some calculated attributes
WITH procedures As (
    select * from {{ ref('stg_procedures') }}
),
encounter AS (
    select * from{{ ref('stg_encounter') }}
),

procedures_modified AS (
    select
        pr.procedure_id,
        pr.patient_id,
        pr.encounter_id,
        pr.start_time,
        pr.stop_time,
        timestamp_diff(pr.stop_time, pr.start_time, MINUTE) AS procedure_duration_minutes,
        extract(year from pr.start_time) AS procedure_year,
        format_timestamp('%b', pr.start_time) AS procedure_month,
        pr.procedure_code,
        pr.procedure_description,
        pr.base_cost,
        pr.reason_code,
        pr.reason_description,
        CASE
            WHEN pr.reason_code IS NOT NULL THEN true
            ELSE false
        END AS has_reason,
        -- categorisation of clinical examinations
        CASE
             -- Renal & Dialysis
            WHEN lower(pr.procedure_description) LIKE '%dialysis%'
            OR lower(pr.procedure_description) LIKE '%renal%'
            OR lower(pr.procedure_description) LIKE '%hemodialysis%'
            THEN 'Renal & Dialysis'

    -- Oncology & Cancer
            WHEN lower(pr.procedure_description) LIKE '%chemotherapy%'
            OR lower(pr.procedure_description) LIKE '%radiation%'
            OR lower(pr.procedure_description) LIKE '%teleradiotherapy%'
            OR lower(pr.procedure_description) LIKE '%biopsy%'
            OR lower(pr.procedure_description) LIKE '%lumpectomy%'
            OR lower(pr.procedure_description) LIKE '%excision of breast%'
            OR lower(pr.procedure_description) LIKE '%sentinel lymph node%'
            OR lower(pr.procedure_description) LIKE '%human epidermal growth%'
            OR lower(pr.procedure_description) LIKE '%fine needle aspiration%'
            THEN 'Oncology & Cancer'

    -- Cardiology
            WHEN lower(pr.procedure_description) LIKE '%cardiac%'
            OR lower(pr.procedure_description) LIKE '%cardioversion%'
            OR lower(pr.procedure_description) LIKE '%echocardiography%'
            OR lower(pr.procedure_description) LIKE '%electrocardiograph%'
            OR lower(pr.procedure_description) LIKE '%cardiovascular%'
            OR lower(pr.procedure_description) LIKE '%catheter ablation%'
            OR lower(pr.procedure_description) LIKE '%coronary%'
            OR lower(pr.procedure_description) LIKE '%heart%'
            OR lower(pr.procedure_description) LIKE '%percutaneous coronary%'
            OR lower(pr.procedure_description) LIKE '%defibrillator%'
            THEN 'Cardiology'

    -- Respiratory
            WHEN lower(pr.procedure_description) LIKE '%pulmonary%'
            OR lower(pr.procedure_description) LIKE '%respiratory%'
            OR lower(pr.procedure_description) LIKE '%spirometry%'
            OR lower(pr.procedure_description) LIKE '%bronchoscopy%'
            OR lower(pr.procedure_description) LIKE '%oxygen%'
            OR lower(pr.procedure_description) LIKE '%ventilation%'
            OR lower(pr.procedure_description) LIKE '%chest x-ray%'
            OR lower(pr.procedure_description) LIKE '%sputum%'
            OR lower(pr.procedure_description) LIKE '%intubation%'
            OR lower(pr.procedure_description) LIKE '%thoracentesis%'
            OR lower(pr.procedure_description) LIKE '%computed tomography of chest%'
            THEN 'Respiratory'

    -- Mental Health
            WHEN lower(pr.procedure_description) LIKE '%depression%'
            OR lower(pr.procedure_description) LIKE '%anxiety%'
            OR lower(pr.procedure_description) LIKE '%mental health%'
            OR lower(pr.procedure_description) LIKE '%cognitive%'
            OR lower(pr.procedure_description) LIKE '%behavioral%'
            OR lower(pr.procedure_description) LIKE '%psychosocial%'
            OR lower(pr.procedure_description) LIKE '%suicide%'
            THEN 'Mental Health'

    -- Maternity & Obstetrics
            WHEN lower(pr.procedure_description) LIKE '%pregnancy%'
            OR lower(pr.procedure_description) LIKE '%childbirth%'
            OR lower(pr.procedure_description) LIKE '%fetal%'
            OR lower(pr.procedure_description) LIKE '%uterine%'
            OR lower(pr.procedure_description) LIKE '%cesarean%'
            OR lower(pr.procedure_description) LIKE '%episiotomy%'
            OR lower(pr.procedure_description) LIKE '%labor%'
            OR lower(pr.procedure_description) LIKE '%prenatal%'
            OR lower(pr.procedure_description) LIKE '%antenatal%'
            OR lower(pr.procedure_description) LIKE '%newborn%'
            OR lower(pr.procedure_description) LIKE '%birth%'
            OR lower(pr.procedure_description) LIKE '%pelvic%'
            OR lower(pr.procedure_description) LIKE '%breech%'
            THEN 'Maternity & Obstetrics'

    -- Screening & Assessment
            WHEN lower(pr.procedure_description) LIKE '%screening%'
            OR lower(pr.procedure_description) LIKE '%assessment%'
            OR lower(pr.procedure_description) LIKE '%examination%'
            OR lower(pr.procedure_description) LIKE '%morse fall%'
            OR lower(pr.procedure_description) LIKE '%alcohol use%'
            OR lower(pr.procedure_description) LIKE '%substance use%'
            OR lower(pr.procedure_description) LIKE '%drug abuse%'
            OR lower(pr.procedure_description) LIKE '%domestic abuse%'
            THEN 'Screening & Assessment'

    -- Diagnostic Imaging
            WHEN lower(pr.procedure_description) LIKE '%x-ray%'
            OR lower(pr.procedure_description) LIKE '%mammograph%'
            OR lower(pr.procedure_description) LIKE '%ultrasound%'
            OR lower(pr.procedure_description) LIKE '%magnetic resonance%'
            OR lower(pr.procedure_description) LIKE '%computed tomography%'
            OR lower(pr.procedure_description) LIKE '%bone density%'
            OR lower(pr.procedure_description) LIKE '%imaging%'
            THEN 'Diagnostic Imaging'

    -- Laboratory & Pathology
            WHEN lower(pr.procedure_description) LIKE '%culture%'
            OR lower(pr.procedure_description) LIKE '%test%'
            OR lower(pr.procedure_description) LIKE '%antigen%'
            OR lower(pr.procedure_description) LIKE '%antibody%'
            OR lower(pr.procedure_description) LIKE '%hemoglobin%'
            OR lower(pr.procedure_description) LIKE '%blood%'
            OR lower(pr.procedure_description) LIKE '%urine%'
            OR lower(pr.procedure_description) LIKE '%cytopathology%'
            OR lower(pr.procedure_description) LIKE '%microbial%'
            OR lower(pr.procedure_description) LIKE '%smear%'
            OR lower(pr.procedure_description) LIKE '%alpha-fetoprotein%'
            THEN 'Laboratory & Pathology'

    -- Surgery & Procedures
            WHEN lower(pr.procedure_description) LIKE '%surgery%'
            OR lower(pr.procedure_description) LIKE '%surgical%'
            OR lower(pr.procedure_description) LIKE '%appendectomy%'
            OR lower(pr.procedure_description) LIKE '%prostatectomy%'
            OR lower(pr.procedure_description) LIKE '%vasectomy%'
            OR lower(pr.procedure_description) LIKE '%colonoscopy%'
            OR lower(pr.procedure_description) LIKE '%polypectomy%'
            OR lower(pr.procedure_description) LIKE '%resection%'
            OR lower(pr.procedure_description) LIKE '%laparoscopic%'
            OR lower(pr.procedure_description) LIKE '%suture%'
            OR lower(pr.procedure_description) LIKE '%extraction%'
            OR lower(pr.procedure_description) LIKE '%incision%'
            THEN 'Surgery & Procedures'

    -- Immunisation & Vaccination
            WHEN lower(pr.procedure_description) LIKE '%vaccination%'
            OR lower(pr.procedure_description) LIKE '%immunization%'
            OR lower(pr.procedure_description) LIKE '%immunotherapy%'
            OR lower(pr.procedure_description) LIKE '%injection%'
            OR lower(pr.procedure_description) LIKE '%antitoxin%'
            THEN 'Immunisation & Vaccination'

    -- Palliative & Hospice Care
            WHEN lower(pr.procedure_description) LIKE '%hospice%'
            OR lower(pr.procedure_description) LIKE '%palliative%'
            OR lower(pr.procedure_description) LIKE '%movement therapy%'
            THEN 'Palliative & Hospice Care'

    -- Contraception & Family Planning
            WHEN lower(pr.procedure_description) LIKE '%contraceptive%'
            OR lower(pr.procedure_description) LIKE '%intrauterine device%'
            OR lower(pr.procedure_description) LIKE '%tubal ligation%'
            OR lower(pr.procedure_description) LIKE '%termination%'
            THEN 'Contraception & Family Planning'

    -- Patient Care & Administration
            WHEN lower(pr.procedure_description) LIKE '%admission%'
            OR lower(pr.procedure_description) LIKE '%discharge%'
            OR lower(pr.procedure_description) LIKE '%transfer%'
            OR lower(pr.procedure_description) LIKE '%monitoring%'
            OR lower(pr.procedure_description) LIKE '%medication reconciliation%'
            OR lower(pr.procedure_description) LIKE '%referral%'
            OR lower(pr.procedure_description) LIKE '%hospice%'
            OR lower(pr.procedure_description) LIKE '%information gathering%'
            THEN 'Patient Care & Administration'
            
            ELSE 'Other'
        END AS procedure_category,
    --encounter attributes
        e.encounterType,
        e.total_cost
    from 
        procedures pr
    LEFT JOIN encounter e 
    ON pr.encounter_id = e.encounter_id

)
select *
from procedures_modified