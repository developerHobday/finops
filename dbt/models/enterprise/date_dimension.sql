WITH date_generator AS (

    SELECT DATEADD(DAY, SEQ4(), '2000-01-01') AS date
    FROM TABLE(GENERATOR(ROWCOUNT=>10000))
)

select
    date,
    YEAR(date) AS year,
    MONTH(date) AS month,
    MONTHNAME(date) AS month_name,
    DAY(date) AS day,
    DAYOFWEEK(date) AS day_of_week, 
    WEEKOFYEAR(date) AS week_of_year,
    DAYOFYEAR(date) AS day_of_year
from date_generator
