create database job_db;
use job_db;
create table job_data
(
job_id int,
actor_id int,
event varchar(50),
language varchar(50),	
time_spent time,
org varchar(100),
ds date
);
insert into job_data (job_id, actor_id, event, language, time_spent, org, ds)
values
('21', '1001', 'skip', 'English', '15', 'A', '2020-11-30'),
('22', '1006', 'transfer', 'Arabic', '25', 'B', '2020-11-30'),
('23','1003', 'decision', 'Persian', '20', 'C', '2020-11-29'),
('23', '1005', 'transfer', 'Persian', '22', 'D', '2020-11-28'),
('25', '1002', 'decision', 'Hindi', '11', 'B', '2020-11-28'),
('11', '1007', 'decision', 'French', '104', 'D', '2020-11-27'),
('23', '1004', 'skip', 'Persian', '56', 'A', '2020-11-26'),
('20', '1003', 'transfer', 'Italian', '45', 'C', '2020-11-25')
;
select * from job_data;

# Jobs Reviewed Over Time:
select distinct ds as Days,
count(job_id) / (sum(time_spent) / 3600) as no_of_jobs_reviewed 
from job_data
group by Days;

# Throughput Analysis:
# Weekly Througput
select round(count(event)/sum(time_spent),2) as "Weekly Throughput"
from job_data;

# Daily Throughput
select ds as Dates, round(count(event)/sum(time_spent),2) as "Daily Throughput"
from job_data
group by ds
order by ds;

# Language Share Analysis:
select language, count(language) as total_language,
count(language)*100/sum(count(language))
over() as percentage
from job_data
group by language
order by language;

# Duplicate rows detection:
select *, count(*) AS Duplicates
from job_data
group by ds, job_id, actor_id, event, language, time_spent, org
having count(*) > 1;