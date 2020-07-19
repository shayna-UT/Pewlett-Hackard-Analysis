-- Mentorship Eligibility:

-- To be eligible to participate in the mentorship program, 
-- employees will need to have a date of birth that falls between January 1, 1965 and December 31, 1965.
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	titles.title,
	de.from_date,
	de.to_date
INTO mentorship_program
FROM employees as e
INNER JOIN titles
	ON (e.emp_no = titles.emp_no)
INNER JOIN dept_emp as de
	ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
	AND (de.to_date = '9999-01-01');

-- Remove duplicates
SELECT emp_no, 
	first_name, 
	last_name, 
	title, 
	from_date, 
	to_date
INTO Mentorship_Eligibility
FROM 
	(SELECT emp_no, 
	first_name, 
	last_name, 
	title, 
	from_date, 
	to_date, ROW_NUMBER() OVER
	(PARTITION BY (emp_no)
	 ORDER BY from_date DESC) rn
	 FROM mentorship_program
	) tmp WHERE rn = 1;

-- Double check for duplicates 
SELECT emp_no, count(*)
FROM mentorship_eligibility
GROUP BY emp_no
HAVING COUNT(*) > 1;