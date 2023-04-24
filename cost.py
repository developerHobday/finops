import boto3
from datetime import datetime, timedelta

client = boto3.client('ce', 'us-east-1')

yesterday = datetime.today() - timedelta(days=1)
start_date = yesterday.replace(hour=0,minute=0, second=0,microsecond=0)
end_date = start_date + timedelta(days=1)

# Valid dimensions - https://docs.aws.amazon.com/aws-cost-management/latest/APIReference/API_GetDimensionValues.html

response = client.get_cost_and_usage(
    TimePeriod={
        'Start': start_date.strftime('%Y-%m-%d'),
        'End': end_date.strftime('%Y-%m-%d')
    },
    Granularity='DAILY',
    Metrics=['UnblendedCost'],
    GroupBy=[
        {
        'Type':"DIMENSION",
        'Key':"SERVICE",
        },
        {
        'Type':"DIMENSION",
        'Key':"USAGE_TYPE",
        },
    ],
    # TODO multiple pages - lower priority for now
)

import json
print( json.dumps(response, indent=2))

import sys
sys.exit(0)

for result in response['ResultsByTime']:
    print(f"Date: {result['TimePeriod']['Start']} - {result['TimePeriod']['End']}")
    print(f"Total Cost: {result['Total']['UnblendedCost']['Amount']}")
    print(f"Cost by Service: ")
    for cost in result['Groups']:
        print(f"{cost['Keys'][0]}: {cost['Metrics']['UnblendedCost']['Amount']}")
    print()
