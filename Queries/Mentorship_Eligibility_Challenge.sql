-- Retrieve the emp_no, first_name, last_name, and birth_date columns from the Employees table.
select emp_no, first_name, last_name, birth_date
into emp_db
from employees
where (birth_date between '1965-01-01' and '1965-12-31');

select * from emp_db;


-- Retrieve the from_date and to_date columns from the Department Employee table.
drop table if exists titles_db;

select from_date, to_date
into titles_db
from dept_emp;

select * from titles_db;


-- Retrieve the title column from the Titles table.
select title from titles;



-- Use a DISTINCT ON statement to retrieve the first occurrence of the employee number for each set of rows defined by the ON () clause.
select distinct on(emp_no) emp_no
from titles;



-- Create a new table using the INTO clause
-- added into clauses to above cells



-- Join the Employees and the Department Employee tables on the primary key.
-- Join the Employees and the Titles tables on the primary key.
-- Filter the data on the to_date column to all the current employees, then filter the data on the birth_date columns to get all the employees whose 
-- birth dates are between January 1, 1965 and December 31, 1965.
-- Order the table by the employee number.
-- See note below.
-- Did it this way because LA helped me out. I was concerned that I wasn't allowed to import the emp_no from the titles table because it wasn't
-- explicitely stated. Last deliverable I imported the emp_no's so you know I can do it both ways. I thought it didn't make much sense that I 
-- wouldn't be able to import the emp_no's because then why would I have to make the tables above? 

drop table if exists mentorship_eligibility;

select distinct on (e.emp_no) e.emp_no,
e.first_name,
e.last_name, 
e.birth_date,
de.from_date,
de.to_date,
ti.title
into mentorship_eligibility
from employees as e
inner join dept_emp as de
on (e.emp_no = de.emp_no)
inner join titles as ti
on (e.emp_no = ti.emp_no)
where (de.to_date = '9999-01-01')
and (e.birth_date between '1965-01-01' and '1965-12-31')
order by e.emp_no;

select * from mentorship_eligibility;




