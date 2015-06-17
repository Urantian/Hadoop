Identify apparently stalled Oozie jobs by querying running jobs based on a threshold.
Jobs running longer than a set period of time will be killed.

This assumes that CDH is running with MySQL as the Oozie workflow database.

1.  The workflow queries the wf_jobs tables to create a list of running jobs.

2.  kill_stalled_jobs.sh queries the Impala table pointing to the list of running jobs, and lists long-running jobs.
The script can ignore specific jobs as necessary.

3.  Any job listed as running past the threshold will be killed, and reported in a log.
