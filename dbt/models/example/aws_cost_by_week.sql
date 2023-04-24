
-- Use the `ref` function to select from other models


SELECT 
    year,
    week_of_year, 
    SUM(cost) AS cost
from FINOPS.PUBLIC.AWS_COST_DETAILS_BY_TIME c 
JOIN  {{ ref('date_dimension') }} d
ON c.start_dt = d.date
GROUP BY year, week_of_year


-- SELECT 
--     year,
--     week_of_year, 
--     SUM(cost) AS cost
-- from FINOPS.PUBLIC.AWS_COST_DETAILS_BY_TIME c 
-- JOIN ANALYTICS.DBT.date_dimension d 
-- ON c.start_dt = d.date
-- GROUP BY year, week_of_year;
