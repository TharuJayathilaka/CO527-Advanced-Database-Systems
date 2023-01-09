USE company;

 -- Question 1
SELECT count(*) FROM employees;
SELECT count(*) FROM dept_manager;
SELECT count(*) FROM dept_emp;
SELECT count(*) FROM titles;
SELECT count(*) FROM salaries;
SELECT count(*) FROM departments;

 -- Question 2
SELECT last_name,COUNT(last_name) AS last_name_count
FROM employees
GROUP BY last_name
ORDER BY last_name_count DESC
LIMIT 10;
    
 -- Question 3
SELECT  departments.dept_name,
count(employees.emp_no) AS 'Number of Engineers'
FROM departments , dept_emp ,employees ,titles
WHERE departments.dept_no=dept_emp.dept_no AND 
dept_emp.emp_no=employees.emp_no AND
employees.emp_no=titles.emp_no AND 
titles.title='Engineer' AND
titles.to_date > curdate()
GROUP BY departments.dept_no;
   
 -- Question 4
SELECT employees.emp_no as ID,concat(first_name," ",last_name) AS emp_name
FROM employees,dept_manager,titles
WHERE employees.emp_no = dept_manager.emp_no
AND employees.emp_no = titles.emp_no 
AND employees.sex="F" AND titles.title = "Senior Engineer" ;

  -- Question 5
  -- Display the departments and titles of employees who have a salary greater than 115000
SELECT departments.dept_no , dept_name , title
FROM departments, salaries, employees, titles, dept_emp
WHERE dept_emp.emp_no = salaries.emp_no 
AND salaries.salary > 115000
AND dept_emp.emp_no = titles.emp_no 
AND departments.dept_no = dept_emp.dept_no
AND employees.emp_no = dept_emp.emp_no
AND salaries.to_date>=CURDATE() 
AND titles.to_date>=CURDATE()
AND dept_emp.to_date>=CURDATE()
ORDER BY departments.dept_no;

 -- Display how many of such employees work for each depart- ment.
SELECT  dept_emp.dept_no AS 'Department_Number' , 
COUNT(dept_emp.emp_no) AS 'No of Employees'
FROM employees,salaries,dept_emp,titles,departments
WHERE employees.emp_no=salaries.emp_no AND 
salaries.salary>115000 AND 
salaries.to_date >= curdate() AND
dept_emp.to_date >=curdate() AND
employees.emp_no=titles.emp_no AND
employees.emp_no=dept_emp.emp_no
GROUP BY Department_Number
ORDER BY departments.dept_no ASC;

  -- Question 6
SELECT concat(employees.first_name," ",employees.last_name) AS employee_name, 
TIMESTAMPDIFF(YEAR,employees.birth_date,CURDATE()) AS age ,
TIMESTAMPDIFF(YEAR,employees.hire_date,CURDATE()) as years_of_service ,
employees.hire_date AS joined_date
FROM employees,titles
WHERE TIMESTAMPDIFF(YEAR,employees.birth_date,CURDATE()) > 50 AND
employees.emp_no=titles.emp_no AND
TIMESTAMPDIFF(YEAR,employees.hire_date,CURDATE())>10;

  -- Question 7
SELECT concat(employees.first_name," ",employees.last_name) AS employees_doesnot_work_in_HR_dept
FROM employees,departments,dept_emp
WHERE departments.dept_name!='Human Resources' AND 
departments.dept_no=dept_emp.dept_no AND
dept_emp.emp_no=employees.emp_no;

  -- Question 8
SELECT employees.first_name , employees.last_name
FROM employees,salaries
WHERE employees.emp_no IN
(SELECT salaries.emp_no FROM salaries )
AND salaries.salary > 
(SELECT MAX(salaries.salary) FROM
salaries,departments,dept_emp,employees
WHERE departments.dept_name='Finance' AND 
departments.dept_no=dept_emp.dept_no AND 
dept_emp.emp_no=employees.emp_no AND 
employees.emp_no=salaries.emp_no);

 -- Question 9
SELECT DISTINCT employees.first_name , employees.last_name
FROM employees,salaries
WHERE salaries.to_date >=curdate() AND 
employees.emp_no=salaries.emp_no AND 
salaries.salary > (SELECT AVG(salaries.salary) FROM salaries);
 
 -- Question 10
SELECT ((SELECT AVG(salaries.salary) FROM salaries) -
(SELECT AVG(salaries.salary) FROM employees,salaries,titles 
WHERE titles.title='Senior Engineer' AND  
titles.emp_no=employees.emp_no AND employees.emp_no=salaries.emp_no)) AS diff;

 -- Question 11
CREATE VIEW current_dept_emp AS
SELECT e.emp_no , de.from_date , de.to_date
FROM employees e
INNER JOIN dept_emp de
ON e.emp_no = de.emp_no;
    
 -- Question 12
SELECT e.emp_no, de.from_date, de.to_date
FROM employees e
INNER JOIN dept_emp de
ON de.emp_no = e.emp_no;
 
 -- Question 13
create table emp_salary_change
	(
		old_salary int,
		new_salary int,
		difference int,
		action VARCHAR(50) DEFAULT NULL
	);
	
delimiter $
create trigger after_salaries_update
after update on salaries
for each row
begin 
insert into emp_salary_change
SET action = 'update',
old_Salary = old.salary,
new_Salary = new.salary,
difference = new.salary-old.salary; 
end $
delimiter ;
 
 -- Question 14
delimiter $
	
create trigger error_salary_update
before update on salaries
for each row
begin
declare msg varchar(50);
if(new.salary-old.salary)>(old.salary*0.1)then
	set msg ="Error : Salary increment > 10%";
	signal sqlstate '45000' set message_text = msg;
end if;
end $
delimiter ;