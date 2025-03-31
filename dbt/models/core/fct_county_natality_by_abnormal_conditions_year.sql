{{
  config(
    materialized='table',
    partition_by={
      "field": "year_date", 
      "data_type": "date",
      "granularity": "year"
    }
  )
}}

WITH 
abnormal_conditions_year as (
    SELECT 
        year_date,
        year,
        abnormal_conditions_checked_desc,
        SUM(births) as births,
        SUM(births * ave_age_of_mother)/sum(births) AS mother_age, 
        SUM(births * ave_oe_gestational_age_wks)/sum(births) AS oe_gestational_age_wks, 
        SUM(births * ave_lmp_gestational_age_wks)/sum(births) AS lmp_gestational_age_wks, 
        SUM(births * ave_birth_weight_gms)/sum(births) AS birth_weight_gms, 
        SUM(births * ave_pre_pregnancy_bmi)/sum(births) AS pre_pregnancy_bmi, 
        SUM(births * ave_number_of_prenatal_wks)/sum(births) AS number_of_prenatal_wks, 
    FROM  {{ ref('stg_county_natality_by_abnormal_conditions') }}
    group by 1,2,3
)

select * FROM abnormal_conditions_year 