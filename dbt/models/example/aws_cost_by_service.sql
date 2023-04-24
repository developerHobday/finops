
/*
    Welcome to your first dbt model!
    Did you know that you can also configure models directly within SQL files?
    This will override configurations stated in dbt_project.yml

    Try changing "table" to "view" below
*/

{{ config(materialized='table') }}

SELECT service, SUM(cost) AS cost
from FINOPS.PUBLIC.AWS_COST_DETAILS_BY_TIME c 
GROUP BY service

/*
    Uncomment the line below to remove records with null `id` values
*/

-- where id is not null
