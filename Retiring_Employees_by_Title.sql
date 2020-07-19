-- Retiring Employees:

--  List of current employees born between Jan. 1, 1952 and Dec. 31, 1955
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	titles.title,
	titles.from_date,
	s.salary
INTO retiring_employees
FROM employees as e
INNER JOIN titles 
	ON (e.emp_no = titles.emp_no)
INNER JOIN salaries as s 
	ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
	ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
		AND (de.to_date = '9999-01-01')
ORDER BY 
	e.first_name ASC,
	e.last_name ASC;

-- Check for duplicates
SELECT * 
INTO retiring_employees_duplicates
FROM
	(SELECT *, COUNT(*)
	OVER 
		(PARTITION BY 
	 	first_name, 
	 last_name
	) AS COUNT
	FROM title_info) tableWithCount
	WHERE tableWithCount.count > 1;

-- Retiring Employees by Title
-- Remove all duplicates
SELECT emp_no, 
	first_name, 
	last_name, 
	title, 
	from_date, 
	salary
INTO retiring_employees_byTitle
FROM 
	(SELECT emp_no, 
	first_name, 
	last_name, 
	title, 
	from_date, 
	salary, ROW_NUMBER() OVER
	(PARTITION BY (emp_no)
	 ORDER BY from_date DESC) rn
	 FROM retiring_employees
	) tmp WHERE rn = 1;

-- Number of Retiring Employees by Title
SELECT COUNT(emp_no), title
INTO retiring_employees_count_byTitle
FROM retiring_employees_byTitle
GROUP BY title