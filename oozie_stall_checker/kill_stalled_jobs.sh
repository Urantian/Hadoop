
impala-shell -q "refresh wf_jobs" -d irdw_prod --quiet -B

jobQuery="select * from wf_jobs where hours_elapsed >= 3 and minutes_elapsed >= 0 and job_name <> '[job to ignore]'

## jobQuery="select * from wf_jobs where job_name like '%Stalled%'"

echo `date` jobQuery: ${jobQuery}

impala-shell -q "${jobQuery}" -d [database] --quiet -B -o job_query.output

while read i; do

   if [ ! -z "$i" ]; then

     job_id=`echo $i | cut -d ' ' -f 1`

     echo `date` --- $i > stalled_jobs.txt
     hadoop fs -appendToFile stalled_jobs.txt [hdfs path]/killed_jobs.txt

     echo "Kill $job_id"
     oozie job -oozie http://[server]:11000/oozie/ -kill $job_id

   fi
done < "job_query.output"
