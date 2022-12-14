--  Data is from https://github.com/vrajmohan/pgsql-sample-data/tree/master/employee
-- Creating tables for PH-EmployeeDB
CREATE TABLE departments (
  dept_no VARCHAR(4) NOT NULL,
  dept_name VARCHAR(40) NOT NULL,
  PRIMARY KEY (dept_no),
  UNIQUE (dept_name)
);

CREATE TABLE employees (
  emp_no INT NOT NULL,
  birth_date DATE NOT NULL,
  first_name VARCHAR NOT NULL,
  last_name VARCHAR NOT NULL,
  gender VARCHAR NOT NULL,
  hire_date DATE NOT NULL,
  PRIMARY KEY (emp_no)
);

CREATE TABLE dept_manager (
	dept_no VARCHAR(4) NOT NULL,
	emp_no INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE dept_emp (
	emp_no INT NOT NULL,
	dept_no VARCHAR(4) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE titles (
	emp_no INT NOT NULL,
	title VARCHAR(50) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no, title, from_date)
);

CREATE TABLE salaries (
	emp_no INT NOT NULL,
	salary INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no, from_date)
);



-- Retrieve the emp_no, first_name, and last_name columns from the Employees table
select distinct emp_no, first_name, last_name
from employees
where (birth_date between '1952-01-01' and '1955-12-31');



-- Retrieve the title, from_date, and to_date columns from the Titles table
select distinct title, from_date, to_date
from titles;



-- Create a new table from titles using the INTO clause
drop table if exists retirement_titles_db;

select emp_no, title, from_date, to_date
into retirement_titles_db
from titles
where (to_date = '9999-01-01');

select * from retirement_titles_db;



-- Create a new table from employees using the INTO clause with employees of retirement age
drop table if exists retirement_employees_db;

select emp_no, first_name, last_name
into retirement_employees_db
from employees
where (birth_date between '1952-01-01' and '1955-12-31');

select * from retirement_employees_db;



-- Creating a merged table using the two tables made with into clause (non-unique titles)
drop table if exists retirement_titles;

select retirement_employees_db.emp_no,
	retirement_employees_db.first_name,
	retirement_employees_db.last_name,
	retirement_titles_db.title,
	retirement_titles_db.from_date,
	retirement_titles_db.to_date
into retirement_titles
FROM retirement_employees_db
left join retirement_titles_db
on retirement_titles_db.emp_no = retirement_employees_db.emp_no;

select * from retirement_titles;

-- Creating a merged table using the two tables made with into clause (unique titles)
drop table if exists unique_titles;

select distinct on (retirement_titles_db.emp_no) retirement_employees_db.emp_no,
	retirement_employees_db.first_name,
	retirement_employees_db.last_name,
	retirement_titles_db.title,
	retirement_titles_db.from_date,
	retirement_titles_db.to_date
into unique_titles
FROM retirement_employees_db
left join retirement_titles_db
on retirement_titles_db.emp_no = retirement_employees_db.emp_no
order by retirement_titles_db.emp_no, retirement_titles_db.from_date desc;

select * from unique_titles;

-- Number of employees by their most recent job title who are about to retire
select count(emp_no), title
into retiring_titles
from unique_titles
where title is not null
group by (title)
order by count desc;

select * from retiring_titles;
