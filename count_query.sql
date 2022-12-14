-- Number of employees by their most recent job title who are about to retire
select count(emp_no), title
into retiring_titles
from unique_titles
where title is not null
group by (title)
order by count desc;

select * from retiring_titles;