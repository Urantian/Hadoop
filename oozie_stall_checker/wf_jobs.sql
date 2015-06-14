drop table if exists irdw_prod.wf_jobs;
create external table irdw_prod.wf_jobs
(
  id string,
  start_date timestamp,
  hours_elapsed int,
  minutes_elapsed int,
  job_name string
)
row format delimited fields terminated by ',' escaped by '\\'
location '/irdw/prod/raw/wf_stall_checker/text'
tblproperties("serialization.null.format"="\\\\N");
