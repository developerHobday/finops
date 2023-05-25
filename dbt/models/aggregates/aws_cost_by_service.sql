WITH costs AS (
    SELECT *
    FROM {{ ref('aws_cost_details') }} 

    {% if target.name == 'dev' %}
    LIMIT 1000
    {% endif %}
)

SELECT service, SUM(cost) AS cost
from costs 
GROUP BY service