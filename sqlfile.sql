CREATE DATABASE Employee_Management_System;
CREATE TABLE JobDepartment (
    Job_ID INT PRIMARY KEY,
    jobdept VARCHAR(50),
    name VARCHAR(100),
    description TEXT,
    salaryrange VARCHAR(50)
);
-- Table 2: Salary/Bonus
CREATE TABLE SalaryBonus (
    salary_ID INT PRIMARY KEY,
    Job_ID INT,
    amount DECIMAL(10,2),
    annual DECIMAL(10,2),
    bonus DECIMAL(10,2),
    CONSTRAINT fk_salary_job FOREIGN KEY (job_ID) REFERENCES JobDepartment(Job_ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);
-- Table 3: Employee
CREATE TABLE Employee (
    emp_ID INT PRIMARY KEY,
    firstname VARCHAR(50),
    lastname VARCHAR(50),
    gender VARCHAR(10),
    age INT,
    contact_add VARCHAR(100),
    emp_email VARCHAR(100) UNIQUE,
    emp_pass VARCHAR(50),
    Job_ID INT,
    CONSTRAINT fk_employee_job FOREIGN KEY (Job_ID)
        REFERENCES JobDepartment(Job_ID)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- Table 4: Qualification
CREATE TABLE Qualification (
    QualID INT PRIMARY KEY,
    Emp_ID INT,
    Position VARCHAR(50),
    Requirements VARCHAR(255),
    Date_In DATE,
    CONSTRAINT fk_qualification_emp FOREIGN KEY (Emp_ID)
        REFERENCES Employee(emp_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Table 5: Leaves
CREATE TABLE Leaves (
    leave_ID INT PRIMARY KEY,
    emp_ID INT,
    date DATE,
    reason TEXT,
    CONSTRAINT fk_leave_emp FOREIGN KEY (emp_ID) REFERENCES Employee(emp_ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Table 6: Payroll
CREATE TABLE Payroll (
    payroll_ID INT PRIMARY KEY,
    emp_ID INT,
    job_ID INT,
    salary_ID INT,
    leave_ID INT,
    date DATE,
    report TEXT,
    total_amount DECIMAL(10,2),
    CONSTRAINT fk_payroll_emp FOREIGN KEY (emp_ID) REFERENCES Employee(emp_ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_payroll_job FOREIGN KEY (job_ID) REFERENCES JobDepartment(job_ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_payroll_salary FOREIGN KEY (salary_ID) REFERENCES SalaryBonus(salary_ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_payroll_leave FOREIGN KEY (leave_ID) REFERENCES Leaves(leave_ID)
        ON DELETE SET NULL ON UPDATE CASCADE
);

USE Employee_Management_System;
SELECT DATABASE();
SHOW TABLES;

-- DATABASE VALIDATION: CHECK ROW COUNT
SELECT COUNT(*) AS Total_Rows
FROM JobDepartqualificationment ;
SELECT COUNT(*) AS Total_Rows
FROM SalaryBonus ;
SELECT COUNT(*) AS Total_Rows
FROM Employee ;
SELECT COUNT(*) AS Total_Rows
FROM Qualification ;
SELECT COUNT(*) AS Total_Rows
FROM Leaves ;
SELECT COUNT(*) AS Total_Rows
FROM Payroll ;
------
USE Employee_Management_System;

-- QUESTION 1.1: Unique Employees
SELECT COUNT(DISTINCT emp_ID) AS Unique_Employees
FROM Employee;

-- QUESTION 1.2: Employees by Department
SELECT
   j.jobdept AS Department,
   COUNT(e.emp_ID) AS Employee_Count
FROM Employee e
JOIN JobDepartment j
    ON e.JOb_ID=j.Job_ID
GROUP BY j.jobdept
ORDER BY Employee_Count DESC;
USE Employee_Management_System;

-- QUESTION 1.3: Average Salary per Department

SELECT
    j.jobdept AS Department,
    ROUND(AVG(s.amount),2) AS Average_Salary
FROM Employee e 
JOIN JobDepartment j
     ON e.Job_ID=j.Job_ID
JOIN SalaryBonus s
     ON j.Job_ID=s.Job_ID	
GROUP BY j.jobdept
ORDER BY Average_Salary DESC;

-- Q4. Top 5 highest-paid employees
SELECT 
    e.emp_ID,
    concat(e.firstname,' ',e.lastname) as Employee_Name,
    j.jobdept as Department,
    j.name as Job_ROle,
    s.amount as Salary
from Employee e 
join JobDepartment j
	on e.Job_id=j.Job_ID
join SalaryBonus s
      on j.Job_ID=s.Job_ID
order by s.amount desc
limit 5;

-- Q5. Total salary expenditure
SELECT
    sum(s.amount) as Total_Salary_Expenditure
from Employee e
join JobDepartment j
     on e.Job_ID=j.Job_ID
join SalaryBonus s
  on j.Job_ID=s.Job_ID;

-- Q6. How many different job roles exist in each department?
select 
    jobdept as Department,
    count(distinct name) as Different_Job_Roles
From JobDepartment
Group by jobdept
order by Different_Job_Roles desc; 

-- Q7. What is the average salary range per department?
SELECT
    jobdept AS Department,
    ROUND(AVG((CAST(REPLACE(TRIM(SUBSTRING_INDEX(salaryrange, '-', 1)),
            '$','') AS DECIMAL(10,2))+CAST(REPLACE(
            TRIM(SUBSTRING_INDEX(salaryrange, '-', -1)),'$','') 
            AS DECIMAL(10,2))) / 2),2) AS Average_Salary_Range
FROM JobDepartment
GROUP BY jobdept
ORDER BY Average_Salary_Range DESC;

-- Q8. Which job roles offer the highest salary?
select
   j.name as Job_Role,
   j.jobdept as Department,
   s.amount as Salary
from JobDepartment j
join SalaryBonus s
    on j.Job_ID=s.job_ID
where s.amount=(select max(amount)
   from SalaryBonus
);

-- Q9. Which departments have the highest total salary allocation?
select 
   j.jobdept as Department,
   sum(s.amount) as Total_Salary_Allocation
from Employee e
join JobDepartment j 
      on e.Job_ID=j.job_ID
join SalaryBonus s
   on j.Job_ID=s.job_ID
group by j.jobdept
order by Total_Salary_Allocation desc;

-- Q10. How many employees have at least one qualification listed?
select
    count(distinct Emp_ID) as Employees_With_Qualification
from Qualification

-- Q11. Which positions require the most qualifications?
select
  Position,
  count(*) as Qualification_Count
from Qualification
group by Position 
order by Qualification_Count desc;

-- Q12. Which employees have the highest number of qualifications?
select
     e.emp_ID,
     concat(e.firstname,' ',e.lastname) as Employee_Name,
     count(q.QualID) as Qualification_Count
from Employee e 
join Qualification q
     on e.emp_ID=q.Emp_ID
group by 
	e.emp_ID,
    e.firstname,
    e.lastname
order by Qualification_Count desc;

-- Q13. Which year had the most employees taking leaves?
select
     year(date) as Leave_Year,
     count(distinct emp_ID) as Employees_Taking_leave
from Leaves
group by year(date)
order by Employees_Taking_leave desc;
  
-- Q14. Average number of leave records per employee by department
select
    j.jobdept as Department,
    round(count(l.leave_ID)/count(distinct e.emp_ID),2) 
         as Avg_Leave_Records_Per_Employee
from Employee e 
join JobDepartment j 
    on e.Job_ID=j.job_ID
left join Leaves l 
	 on e.Job_ID=l.emp_ID
group by j.jobdept
order by Avg_Leave_Records_Per_Employee desc;

-- Q15. Which employees have taken the most leaves?
select 
    e.emp_ID,
    concat(e.firstname,' ',e.lastname) as Employee_Name,
    count(l.leave_ID) as Leave_COunt
from employee e 
join leaves l 
     on e.emp_ID=l.emp_ID
group by
    e.emp_ID,
    e.firstname,
    e.lastname
order by Leave_Count desc;

-- Q16. Total leave records company-wide
select
  count(*) as Total_Leave_Records
from Leaves;

-- Q17. Leave records and payroll amounts
select
  e.emp_ID,
  concat(e.firstname,' ',e.lastname) as Employee_Name,
  count(l.leave_ID) as Leave_Count,
  p.total_amount as Payroll_Amount
from Employee e
left join Leaves l
   on e.emp_ID=l.emp_ID
left join Payroll p
   on e.emp_ID=p.emp_ID
group by
   e.emp_ID,
   e.firstname,
   e.lastname,
   p.total_amount
order by Leave_Count desc;
  
-- Q18. What is the total monthly payroll processed?
select
     date_format(date,'%Y-%m') as Payroll_Month,
     sum(total_amount) as Total_Monthly_Payroll
from Payroll
group by date_format(date,'%Y-%m')
order by Payroll_Month;

-- Q19. What is the average bonus given per department?
select
   j.jobdept as Department,
   round(avg(s.bonus),2) as Average_Bonus
from employee e
join JobDepartment j 
    on e.Job_ID=j.Job_ID
join SalaryBonus s 
    on j.Job_ID=s.Job_ID
group by j.jobdept
order by Average_Bonus desc;

-- Q20. Which department receives the highest total bonuses?
select
   j.jobdept as Department,
   sum(s.bonus) as Total_Bonus
from employee e
join JobDepartment j 
    on e.Job_ID=j.Job_ID
join SalaryBonus s 
    on j.Job_ID=s.Job_ID
group by j.jobdept
order by Total_Bonus desc;

-- Q21. What is the average value of total_amount?
select
   round(avg(total_amount),2) as Average_Total_Amount
from Payroll;
   