impala-shell -q "refresh wf_jobs" -d irdw_prod --quiet -B

jobQuery="select * from wf_jobs where hours_elapsed >= 3 and minutes_elapsed >= 0 and job_name <> 'PROD-ComputeStats' and job_name <> 'PROD-ImportClickFact-Reload-Launcher' and job_name <> 'PROD-ImportClickFact-Reload-Shard' and job_name <> 'PROD-ImportClickFact-V4-Archive-Reload' and job_name <> 'PROD-ImportClickFact-V4-Current-Reload' and job_name <> 'CompactActivityAdvEndaggs' and job_name <> 'CompactActivityAdvMpviewEndaggs'" and job_name <> 'CompactFacts'

## jobQuery="select * from wf_jobs where job_name like '%Stalled%'"

echo `date` jobQuery: ${jobQuery}

impala-shell -q "${jobQuery}" -d irdw_prod --quiet -B -o job_query.output

while read i; do

   if [ ! -z "$i" ]; then

     job_id=`echo $i | cut -d ' ' -f 1`

     echo `date` --- $i > stalled_jobs.txt
     hadoop fs -appendToFile stalled_jobs.txt /irdw/prod/raw/wf_stall_checker/etl/killed_jobs.txt

     echo "Kill $job_id"
     oozie job -oozie http://app13.chassis2.phx.impactradius.net:11000/oozie/ -kill $job_id

   fi
done < "job_query.output"
