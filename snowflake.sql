CREATE OR REPLACE DATABASE finops;
USE SCHEMA finops.public;
CREATE OR REPLACE TABLE aws_cost_raw (
  src variant
);

CREATE STORAGE INTEGRATION aws_s3_integration
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::738662219515:role/snowflake_role'
  STORAGE_ALLOWED_LOCATIONS = ('s3://finops-738662219515/');
DESC INTEGRATION aws_s3_integration;
GRANT CREATE STAGE ON SCHEMA public TO ROLE accountadmin;
GRANT USAGE ON INTEGRATION aws_s3_integration TO ROLE accountadmin;

CREATE OR REPLACE STAGE s3_cost
  URL = 's3://finops-738662219515/cost'
  STORAGE_INTEGRATION = aws_s3_integration
  FILE_FORMAT = (TYPE = 'JSON');


COPY INTO aws_cost_raw 
    FROM '@s3_cost/20230114-20230424.json'
    FILE_FORMAT = (TYPE=JSON);

COPY INTO aws_cost_raw 
    FROM '@s3_cost/20230114-20230424.json'
    FILE_FORMAT = (TYPE=JSON);

SELECT * FROM aws_cost_raw;

SELECT src:ResponseMetadata:HTTPHeaders:date::string as date
  FROM aws_cost_raw;

-- Flatten tutorial - https://docs.snowflake.com/en/user-guide/json-basics-tutorial
CREATE OR REPLACE TABLE aws_cost_details_by_time AS
SELECT
  results.value:TimePeriod:Start::date as start_dt,
  groups.value:Keys[0]::string as service,
  groups.value:Keys[1]::string as usage_type,
  groups.value:Metrics:AmortizedCost:Amount::string as cost,
  groups.value:Metrics:AmortizedCost:Unit::string as unit,
  results.value:TimePeriod:End::date as end_dt
FROM
    aws_cost_raw AS raw, 
    LATERAL FLATTEN( INPUT => raw.src, PATH => 'ResultsByTime') AS results,
    LATERAL FLATTEN( INPUT => results.value, PATH => 'Groups') AS groups
ORDER BY start_dt;

SELECT keys[0] FROM aws_cost_details_by_time;

-- Aggregate by service
SELECT service, sum(cost)
FROM aws_cost_details_by_time
GROUP BY service;

-- Aggregate by month

-- Aggregate by week

