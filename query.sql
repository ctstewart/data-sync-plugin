select
tt_users.name,
tt_log.date,
tt_log.start,
addtime(tt_log.start, tt_log.duration) as end,
tt_log.duration,
tt_projects.name as project,
tt_tasks.name as task,
tt_log.comment
from tt_log
inner join tt_users
on tt_log.user_id = tt_users.id
left join tt_projects
on tt_log.project_id = tt_projects.id
left join tt_tasks
on tt_log.task_id = tt_tasks.id
order by tt_log.date, tt_log.start;