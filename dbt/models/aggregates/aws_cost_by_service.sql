SELECT service, SUM(cost) AS cost
from {{ ref('aws_cost_details') }} c 
GROUP BY service