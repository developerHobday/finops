SELECT 
    year,
    week_of_year, 
    SUM(cost) AS cost
from {{ ref('aws_cost_details') }} c 
JOIN  {{ ref('date_dimension') }} d
ON c.start_dt = d.date
GROUP BY year, week_of_year