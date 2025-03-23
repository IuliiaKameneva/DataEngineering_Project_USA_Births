{{ config(materialized='table') }}

WITH 
maternal_morbidity_table as (
    SELECT 
        maternal_morbidity_desc,
        SUM(births) as births,
        SUM(births * ave_age_of_mother)/sum(births) AS mother_age, 
        SUM(births * ave_oe_gestational_age_wks)/sum(births) AS oe_gestational_age_wks, 
        SUM(births * ave_lmp_gestational_age_wks)/sum(births) AS lmp_gestational_age_wks, 
        SUM(births * ave_birth_weight_gms)/sum(births) AS birth_weight_gms, 
        SUM(births * ave_pre_pregnancy_bmi)/sum(births) AS pre_pregnancy_bmi, 
        SUM(births * ave_number_of_prenatal_wks)/sum(births) AS number_of_prenatal_wks, 
        -- year, 
        -- month,
        -- PERCENTILE_CONT(fare_amount, 0.9) OVER (PARTITION BY service_type, year, month) AS p90,
        -- PERCENTILE_CONT(fare_amount, 0.95) OVER (PARTITION BY service_type, year, month) AS p95,
        -- PERCENTILE_CONT(fare_amount, 0.97) OVER (PARTITION BY service_type, year, month) AS p97,
    FROM  {{ ref('stg_county_natality_by_maternal_morbidity') }}
    group by maternal_morbidity_desc
)

select * FROM maternal_morbidity_table 