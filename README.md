The Employee Management System (EMS) is designed to streamline the management of employee data, job roles, and departmental information within an organization. This system allows for efficient tracking of employee details, job assignments, qualifications, and performance metrics. Key domain knowledge elements for this system include:
Employee Information Management: The system stores personal details of employees such as name, contact information, gender, and unique login credentials. It is crucial for ensuring secure access and easy retrieval of employee records.
Job Role Assignment: Each employee is associated with a specific job role, which is linked to the department they work in. This connection ensures that employees are correctly aligned with their job functions and responsibilities within the organization.
Departmental Structure: The organization is divided into various departments (e.g., HR, Finance, IT), each with distinct job roles. The system should manage these departments and the employees assigned to each role efficiently.
Payroll and Compensation: Employee compensation details, including salary and bonuses, are stored in the system. Payroll processing and salary allocations are automatically calculated based on the job roles and associated salary ranges.
Qualifications and Skills Tracking: The system tracks employee qualifications, certifications, and skills to ensure that employees meet the requirements for their roles and identify opportunities for professional development.
Leave and Absence Management: The system manages employee leave records, including vacation days, sick leaves, and other types of absences, with appropriate deductions applied to payroll based on the employee’s leave history.
This system ensures that all employee-related information is stored securely, easily accessible for reporting, and aligned with organizational goals for performance, compensation, and growth.

Table Structures
-- Table 1: Job Department
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


Foreign Key Constraints:
Cascading Delete/Update: For most relationships, the ON DELETE CASCADE and ON UPDATE CASCADE actions are used, meaning that if a record in the parent table (e.g., Employee, JobDepartment) is deleted or updated, the corresponding records in the child tables (e.g., SalaryBonus, Payroll) are automatically deleted or updated as well.


Set Null on Delete: For the relationship between the Payroll and Leaves tables, ON DELETE SET NULL is used. If a leave record is deleted, the related payroll record will not be deleted, but the reference to the leave record will be set to null.

Problem Statement:
The objective of this project is to design and implement an Employee Management System that efficiently stores and manages employee-related data within an organization. The system needs to track various aspects of employee information, including personal details, job roles, salary structures, qualifications, leave records, and payroll data. The system should ensure the integrity and consistency of data by using relational tables with appropriate foreign keys and cascading actions.
The system should allow for easy management and querying of employee data, providing insights such as payroll calculation, leave tracking, and department-specific job roles. The goal is to streamline HR operations, ensuring that all relevant employee data is accessible and accurately updated across different modules.
