import boto3
from datetime import datetime, timedelta


'''
This file contains code that will extract detailed AWS cost data and write it to S3

Pre-req
1. configure aws account to have access to cost explorer
2. Delete access to the billing console to IAM users
https://docs.aws.amazon.com/IAM/latest/UserGuide/tutorial_billing.html
(the IAM user will have to sign out and sign back in.  It seems to take immediate effect.)

'''

def get_daily_cost_detail(start_date, end_date, dimensions) :
    print(f'Start get_daily_cost_detail for {start_date} {end_date} {dimensions}')
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


def get_day(date) :
    return date.replace(hour=0,minute=0, second=0,microsecond=0)

yesterday = datetime.today() - timedelta(days=1)
start_date = yesterday.replace(hour=0,minute=0, second=0,microsecond=0)
end_date = start_date + timedelta(days=1)

start_date = get_day( datetime.today() - timedelta(days=100) )
end_date = get_day(datetime.today())



dimensions = ["SERVICE", "USAGE_TYPE"]

response = get_daily_cost_detail(start_date, end_date, dimensions)

def write_to_s3(filename, body) :
    print('Start write_to_s3')
    import json
    # print( json.dumps(response, indent=2))
    s3 = boto3.resource('s3')
    bucket_name = 'finops-738662219515'
    bucket = s3.Bucket(bucket_name) 

    obj = bucket.Object(f'cost/{filename}.json')
    obj.put(
        Body=(bytes(json.dumps(body).encode('UTF-8')))
    )

filename = f'{start_date.strftime("%Y%m%d")}-{end_date.strftime("%Y%m%d")}'
write_to_s3(filename, response)

# TODO terraform for S3
# TODO refactor


