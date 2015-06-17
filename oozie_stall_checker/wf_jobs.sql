drop table if exists [database].wf_jobs;
create external table [database].wf_jobs
(
  id string,
  start_date timestamp,
  hours_elapsed int,
  minutes_elapsed int,
  job_name string
)
row format delimited fields terminated by ',' escaped by '\\'
location '[hdfs path]/wf_stall_checker/text'
tblproperties("serialization.null.format"="\\\\N");
