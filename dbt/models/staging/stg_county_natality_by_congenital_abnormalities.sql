{{ config(materialized='view') }}

with source as (

    select *,
    from {{ source('staging', 'county_natality_by_congenital_abnormalities') }}

),

renamed as (

    select
        {{ dbt_utils.generate_surrogate_key(['Year', 'County_of_Residence_FIPS']) }} as record_id,
        EXTRACT(YEAR FROM Year) AS year,
        county_of_residence,
        {{ dbt.safe_cast("county_of_residence_fips", api.Column.translate_type("integer")) }} as county_of_residence_fips,
        congenital_abnormality_checked_desc,
        {{ dbt.safe_cast("congenital_abnormality_checked_yn", api.Column.translate_type("integer")) }} as congenital_abnormality_checked_yn,
        cast(births as numeric) as births,
        cast(ave_age_of_mother as numeric) as ave_age_of_mother,
        cast(ave_oe_gestational_age_wks as numeric) as ave_oe_gestational_age_wks,
        cast(ave_lmp_gestational_age_wks as numeric) as ave_lmp_gestational_age_wks,
        cast(ave_birth_weight_gms as numeric) as ave_birth_weight_gms,
        cast(ave_pre_pregnancy_bmi as numeric) as ave_pre_pregnancy_bmi,
        cast(ave_number_of_prenatal_wks as numeric) as ave_number_of_prenatal_wks,


    from source
)

select * from renamed
