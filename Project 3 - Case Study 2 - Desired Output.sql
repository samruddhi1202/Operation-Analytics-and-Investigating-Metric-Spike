use investigating_metrics;

select * from users;
select * from events;
select * from email_events;

# Weekly User Engagement:
select extract(week from occurred_at) as week_num,
count(distinct user_id) as active_users
from events
where event_type = 'engagement'
group by week_num
order by week_num; 

# User Growth Analysis:
select year, week_num, num_users, sum(num_users)
over(order by year, week_num) as cum_users
from (
select extract(year from created_at) as year, extract(week from created_at) as week_num, count(distinct user_id) as num_users
from users
where state = 'active'
group by year, week_num
order by year, week_num)sub;

# Weekly Retention Analysis:
SELECT first AS "Week Numbers",
SUM(CASE WHEN week_number = 0 THEN 1 ELSE 0 END) AS "Week 0",
SUM(CASE WHEN week_number = 1 THEN 1 ELSE 0 END) AS "Week 1",
SUM(CASE WHEN week_number = 2 THEN 1 ELSE 0 END) AS "Week 2",
SUM(CASE WHEN week_number = 3 THEN 1 ELSE 0 END) AS "Week 3",
SUM(CASE WHEN week_number = 4 THEN 1 ELSE 0 END) AS "Week 4",
SUM(CASE WHEN week_number = 5 THEN 1 ELSE 0 END) AS "Week 5",
SUM(CASE WHEN week_number = 6 THEN 1 ELSE 0 END) AS "Week 6",
SUM(CASE WHEN week_number = 7 THEN 1 ELSE 0 END) AS "Week 7",
SUM(CASE WHEN week_number = 8 THEN 1 ELSE 0 END) AS "Week 8",
SUM(CASE WHEN week_number = 9 THEN 1 ELSE 0 END) AS "Week 9",
SUM(CASE WHEN week_number = 10 THEN 1 ELSE 0 END) AS "Week 10",
SUM(CASE WHEN week_number = 11 THEN 1 ELSE 0 END) AS "Week 11",
SUM(CASE WHEN week_number = 12 THEN 1 ELSE 0 END) AS "Week 12",
SUM(CASE WHEN week_number = 13 THEN 1 ELSE 0 END) AS "Week 13",
SUM(CASE WHEN week_number = 14 THEN 1 ELSE 0 END) AS "Week 14",
SUM(CASE WHEN week_number = 15 THEN 1 ELSE 0 END) AS "Week 15",
SUM(CASE WHEN week_number = 16 THEN 1 ELSE 0 END) AS "Week 16",
SUM(CASE WHEN week_number = 17 THEN 1 ELSE 0 END) AS "Week 17",
SUM(CASE WHEN week_number = 18 THEN 1 ELSE 0 END) AS "Week 18"
From
(
SELECT m.user_id, m.login_week, n.first, m.login_week - first as week_number
FROM
(SELECT user_id, EXTRACT(WEEK FROM occurred_at) AS login_week from events
GROUP BY 1, 2) m,
(SELECT user_id, MIN(EXTRACT(WEEK FROM occurred_at)) AS first from events
GROUP BY 1) n
WHERE m.user_id = n.user_id
) sub
GROUP BY first
ORDER BY first;

# Weekly Engagement Per Device:
SELECT EXTRACT(WEEK FROM occurred_at) AS "Week Numbers", 
COUNT(DISTINCT CASE WHEN device IN('dell inspiron notebook') THEN user_id ELSE
NULL END) AS "Dell Inspiron Notebook",
COUNT(DISTINCT CASE WHEN device IN('iphone 5') THEN user_id ELSE
NULL END) AS "iphone 5",
COUNT(DISTINCT CASE WHEN device IN('iphone 4s') THEN user_id ELSE
NULL END) AS "iphone 4s",
COUNT(DISTINCT CASE WHEN device IN('windows surface') THEN user_id ELSE
NULL END) AS "windows surface",
COUNT(DISTINCT CASE WHEN device IN('macbook air') THEN user_id ELSE
NULL END) AS "macbook air",
COUNT(DISTINCT CASE WHEN device IN('iphone 5s') THEN user_id ELSE
NULL END) AS "iphone 5s",
COUNT(DISTINCT CASE WHEN device IN('macbook pro') THEN user_id ELSE
NULL END) AS "macbook pro",
COUNT(DISTINCT CASE WHEN device IN('kindle fire') THEN user_id ELSE
NULL END) AS "kindle fire",
COUNT(DISTINCT CASE WHEN device IN('ipad mini') THEN user_id ELSE
NULL END) AS "ipad mini",
COUNT(DISTINCT CASE WHEN device IN('nexus 7') THEN user_id ELSE
NULL END) AS "nexus 7",
COUNT(DISTINCT CASE WHEN device IN('nexus 5') THEN user_id ELSE
NULL END) AS "nexus 5",
COUNT(DISTINCT CASE WHEN device IN('samsung galaxy s4') THEN user_id ELSE
NULL END) AS "samsung galaxy s4",
COUNT(DISTINCT CASE WHEN device IN('lenovo thinkpad') THEN user_id ELSE
NULL END) AS "lenovo thinkpad",
COUNT(DISTINCT CASE WHEN device IN('samsumg galaxy tablet') THEN user_id ELSE
NULL END) AS "samsumg galaxy tablet",
COUNT(DISTINCT CASE WHEN device IN('acer aspire notebook') THEN user_id ELSE
NULL END) AS "acer aspire notebook",
COUNT(DISTINCT CASE WHEN device IN('asus chromebook') THEN user_id ELSE
NULL END) AS "asus chromebook",
COUNT(DISTINCT CASE WHEN device IN('htc one') THEN user_id ELSE
NULL END) AS "htc one",
COUNT(DISTINCT CASE WHEN device IN('nokia lumia 635') THEN user_id ELSE
NULL END) AS "nokia lumia 635",
COUNT(DISTINCT CASE WHEN device IN('samsung galaxy note') THEN user_id ELSE
NULL END) AS "samsung galaxy note",
COUNT(DISTINCT CASE WHEN device IN('acer aspire desktop') THEN user_id ELSE
NULL END) AS "acer aspire desktop",
COUNT(DISTINCT CASE WHEN device IN('mac mini') THEN user_id ELSE
NULL END) AS "mac mini",
COUNT(DISTINCT CASE WHEN device IN('hp pavilion desktop') THEN user_id ELSE
NULL END) AS "hp pavilion desktop",
COUNT(DISTINCT CASE WHEN device IN('dell inspiron desktop') THEN user_id ELSE
NULL END) AS "dell inspiron desktop",
COUNT(DISTINCT CASE WHEN device IN('ipad air') THEN user_id ELSE
NULL END) AS "ipad air",
COUNT(DISTINCT CASE WHEN device IN('amazon fire phone') THEN user_id ELSE
NULL END) AS "amazon fire phone",
COUNT(DISTINCT CASE WHEN device IN('nexus 10') THEN user_id ELSE
NULL END) AS "nexus 10"
FROM events
WHERE event_type = 'engagement'
GROUP BY 1
ORDER BY 1; 
# (group/order by 1,2,3 also means group/order by year_num, week_num, device)

# Email Engagement Analysis:
SELECT Week,
ROUND((weekly_digest/total*100),2) as "Weekly Digest Rate",
ROUND((email_opens/total*100),2) as "Email Open Rate",
ROUND((email_clickthroughs/total*100),2) as "Email Clickthrough Rate",
ROUND((reengagement_emails/total*100),2) as "Reengagement Email Rate"
FROM
(
SELECT EXTRACT(WEEK FROM occurred_at) as Week,
COUNT(CASE WHEN action = 'sent_weekly_digest' THEN user_id ELSE NULL END) as
weekly_digest,
COUNT(CASE WHEN action = 'email_open' THEN user_id ELSE NULL END) as
email_opens,
COUNT(CASE WHEN action = 'email_clickthrough' THEN user_id ELSE NULL END) as
email_clickthroughs,
COUNT(CASE WHEN action = 'sent_reengagement_email' THEN user_id ELSE NULL END) as
reengagement_emails,
COUNT(user_id) AS total
FROM email_events
GROUP BY 1
) sub
GROUP BY 1
ORDER BY 1;