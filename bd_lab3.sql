CREATE TABLE employees (
    emp_id  SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name  VARCHAR(50) NOT NULL,
    department VARCHAR(50),
    salary   INTEGER DEFAULT 40000,
    hire_date DATE,
    status  VARCHAR(20) DEFAULT 'Active'
);
CREATE TABLE departments (
    dept_id  SERIAL PRIMARY KEY,
    dept_name  VARCHAR(50) NOT NULL,
    budget  INTEGER,
    manager_id  INTEGER
);

CREATE TABLE projects (
    project_id  SERIAL PRIMARY KEY,
    project_name VARCHAR(100) NOT NULL,
    dept_id  INTEGER,
    start_date  DATE,
    end_date  DATE,
    budget   INTEGER
);

INSERT INTO employees (first_name, last_name, department, salary, hire_date, status) VALUES
('John',   'Smith',   'IT',        55000, '2018-03-01', 'Active'),
('Mary',   'Jones',   'IT',        72000, '2019-07-15', 'Active'),
('Alice',  'Brown',   'Sales',     48000, '2021-05-20', 'Active'),
('Bob',    'Davis',   'Sales',     91000, '2016-01-10', 'Active'),
('Carl',   'Wilson',  'HR',        39000, '2022-09-01', 'Active'),
('Dana',   'Miller',  NULL,        NULL,  '2023-06-01', 'Inactive'),
('Eva',    'Moore',   'Finance',   65000, '2017-11-11', 'Active');

INSERT INTO departments (dept_name, budget, manager_id) VALUES
('IT',      150000, 1),
('Sales',   120000, 4),
('HR',      80000,  5);

INSERT INTO projects (project_name, dept_id, start_date, end_date, budget) VALUES
('CRM Upgrade',      1, '2022-01-01', '2022-12-31', 60000),
('Website Redesign',  1, '2021-01-01', '2021-06-30', 30000),
('Sales Expansion',  2, '2023-01-01', '2024-01-01', 80000);

INSERT INTO employees (emp_id, first_name, last_name, department)
VALUES (100, 'Frank', 'Taylor', 'Marketing');

INSERT INTO employees (first_name, last_name, department, salary, hire_date, status)
VALUES ('Grace', 'Lee', 'IT', DEFAULT, '2024-01-05', DEFAULT);

INSERT INTO departments (dept_name, budget, manager_id) VALUES
('Finance',   95000, 7),
('Marketing', 70000, 100),
('Legal',     60000, NULL);

INSERT INTO employees (first_name, last_name, department, salary, hire_date, status)
VALUES ('Henry', 'Adams', 'IT', 50000 * 1.1, CURRENT_DATE, 'Active');

CREATE TEMP TABLE temp_employees AS
SELECT * FROM employees WHERE department = 'IT' WITH NO DATA;

INSERT INTO temp_employees
SELECT * FROM employees WHERE department = 'IT';

UPDATE employees
SET salary = salary * 1.10
WHERE salary IS NOT NULL;

UPDATE employees
SET status = 'Senior'
WHERE salary > 60000
  AND hire_date < '2020-01-01';

UPDATE employees
SET department = CASE
    WHEN salary > 80000 THEN 'Management'
    WHEN salary BETWEEN 50000 AND 80000 THEN 'Senior'
    ELSE 'Junior'
END
WHERE salary IS NOT NULL;

UPDATE employees
SET department = DEFAULT
WHERE status = 'Inactive';

UPDATE departments d
SET budget = sub.avg_salary * 1.20
FROM (
    SELECT department, AVG(salary) AS avg_salary
    FROM employees
    WHERE salary IS NOT NULL
    GROUP BY department
) AS sub
WHERE d.dept_name = sub.department;

UPDATE employees
SET salary = salary * 1.15,
    status = 'Promoted'
WHERE department = 'Sales';

DELETE FROM employees
WHERE status = 'Terminated';

DELETE FROM employees
WHERE salary < 40000
  AND hire_date > '2023-01-01'
  AND department IS NULL;

DELETE FROM departments
WHERE dept_id NOT IN (
    SELECT DISTINCT dept_id
    FROM employees e
    JOIN departments dd ON e.department = dd.dept_name
    WHERE e.department IS NOT NULL
);

DELETE FROM projects
WHERE end_date < '2023-01-01'
RETURNING *;

INSERT INTO employees (first_name, last_name, department, salary, hire_date, status)
VALUES ('Ian', 'Clark', NULL, NULL, '2024-02-01', 'Active');

UPDATE employees
SET department = 'Unassigned'
WHERE department IS NULL;

DELETE FROM employees
WHERE salary IS NULL OR department IS NULL;

INSERT INTO employees (first_name, last_name, department, salary, hire_date, status)
VALUES ('Julia', 'Roberts', 'IT', 58000, '2024-03-01', 'Active')
RETURNING emp_id, first_name || ' ' || last_name AS full_name;

WITH old_values AS (
    SELECT emp_id, salary AS old_salary
    FROM employees
    WHERE department = 'IT'
)
UPDATE employees e
SET salary = e.salary + 5000
FROM old_values o
WHERE e.emp_id = o.emp_id
RETURNING e.emp_id, o.old_salary, e.salary AS new_salary;

DELETE FROM employees
WHERE hire_date < '2020-01-01'
RETURNING *;

INSERT INTO employees (first_name, last_name, department, salary, hire_date, status)
SELECT 'Kevin', 'White', 'Sales', 52000, '2024-04-01', 'Active'
WHERE NOT EXISTS (
    SELECT 1 FROM employees
    WHERE first_name = 'Kevin' AND last_name = 'White'
);

UPDATE employees e
SET salary = CASE
    WHEN (SELECT d.budget FROM departments d WHERE d.dept_name = e.department) > 100000
        THEN e.salary * 1.10
    ELSE e.salary * 1.05
END
WHERE e.department IN (SELECT dept_name FROM departments);

INSERT INTO employees (first_name, last_name, department, salary, hire_date, status) VALUES
('Liam',  'Turner',  'Marketing', 45000, '2024-05-01', 'Active'),
('Mia',   'Scott',   'Marketing', 47000, '2024-05-02', 'Active'),
('Noah',  'Baker',   'Marketing', 46000, '2024-05-03', 'Active'),
('Olivia','Hall',    'Marketing', 48000, '2024-05-04', 'Active'),
('Peter', 'Young',   'Marketing', 44000, '2024-05-05', 'Active');

UPDATE employees
SET salary = salary * 1.10
WHERE first_name IN ('Liam', 'Mia', 'Noah', 'Olivia', 'Peter')
  AND hire_date BETWEEN '2024-05-01' AND '2024-05-05';

CREATE TABLE employee_archive (
    emp_id      INTEGER PRIMARY KEY,
    first_name  VARCHAR(50),
    last_name   VARCHAR(50),
    department  VARCHAR(50),
    salary      INTEGER,
    hire_date   DATE,
    status      VARCHAR(20)
);

INSERT INTO employee_archive
SELECT * FROM employees WHERE status = 'Inactive';

DELETE FROM employees WHERE status = 'Inactive';

UPDATE projects p
SET end_date = end_date + INTERVAL '30 days'
WHERE p.budget > 50000
  AND p.dept_id IN (
      SELECT e_dept.dept_id
      FROM departments e_dept
      JOIN employees e ON e.department = e_dept.dept_name
      GROUP BY e_dept.dept_id
      HAVING COUNT(e.emp_id) > 3
  );



