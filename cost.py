import boto3
from datetime import datetime, timedelta

def get_daily_cost_detail(start_date, end_date, dimensions) :
    client = boto3.client('ce', 'us-east-1')

    # api documentation - https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/ce/client/get_cost_and_usage.html
    response = client.get_cost_and_usage(
        TimePeriod={
            'Start': start_date.strftime('%Y-%m-%d'),
            'End': end_date.strftime('%Y-%m-%d')
        },
        Granularity='DAILY',
        Metrics=['AmortizedCost'], # Explanation -  https://aws.amazon.com/blogs/aws-cloud-financial-management/understanding-your-aws-cost-datasets-a-cheat-sheet/
        GroupBy = [ {
            'Type':"DIMENSION",
            'Key': dimension,
        } for dimension in dimensions ],
    )

    if 'NextPageToken' in response : 
        raise ValueError('Need to handle for multiple pages!') # TODO - multiple pages

    return response


yesterday = datetime.today() - timedelta(days=1)
start_date = yesterday.replace(hour=0,minute=0, second=0,microsecond=0)
end_date = start_date + timedelta(days=1)

dimensions = ["SERVICE", "USAGE_TYPE"]

response = get_daily_cost_detail(start_date, end_date, dimensions)

import json
print( json.dumps(response, indent=2))

