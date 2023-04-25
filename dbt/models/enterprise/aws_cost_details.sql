SELECT
  results.value:TimePeriod:Start::date as start_dt,
  groups.value:Keys[0]::string as service,
  groups.value:Keys[1]::string as usage_type,
  groups.value:Metrics:AmortizedCost:Amount::string as cost,
  groups.value:Metrics:AmortizedCost:Unit::string as unit,
  results.value:TimePeriod:End::date as end_dt
FROM
    finops.public.aws_cost_raw AS raw, 
    LATERAL FLATTEN( INPUT => raw.src, PATH => 'ResultsByTime') AS results,
    LATERAL FLATTEN( INPUT => results.value, PATH => 'Groups') AS groups
