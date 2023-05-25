WITH costs AS (
    SELECT *
    FROM {{ ref('aws_cost_details') }} 
),
dates AS (
    SELECT * 
    FROM {{ ref('date_dimension') }}
)

SELECT 
    year,
    week_of_year, 
    SUM(cost) AS cost
FROM costs c JOIN dates d ON c.start_dt = d.date
GROUP BY 1,2