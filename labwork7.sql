CREATE TABLE departments (dept_id INT PRIMARY KEY, dept_name VARCHAR(50), location VARCHAR(50));
CREATE TABLE employees (emp_id INT PRIMARY KEY, emp_name VARCHAR(100), dept_id INT, salary NUMERIC(10,2));
CREATE TABLE projects (project_id INT PRIMARY KEY, project_name VARCHAR(100), dept_id INT, budget NUMERIC(12,2));
INSERT INTO departments VALUES (101,'IT','Building A'),(102,'HR','Building B'),(103,'Operations','Building C');
INSERT INTO employees VALUES
 (1,'John Smith',101,50000),(2,'Jane Doe',102,60000),(3,'Mike Johnson',101,55000),
 (4,'Sarah Williams',102,65000),(5,'Tom Brown',NULL,45000);
INSERT INTO projects VALUES (201,'Website Redesign',101,100000),(202,'Employee Training',102,50000),(203,'Budget Analysis',103,175000);

-- 2.1
CREATE VIEW employee_details AS
SELECT e.emp_name, e.salary, d.dept_name, d.location
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id;
SELECT * FROM employee_details;

-- 2.2
CREATE VIEW dept_statistics AS
SELECT d.dept_id, d.dept_name,
       COUNT(e.emp_id) AS employee_count,
       ROUND(AVG(e.salary),2) AS avg_salary,
       MAX(e.salary) AS max_salary,
       MIN(e.salary) AS min_salary
FROM departments d
LEFT JOIN employees e ON e.dept_id = d.dept_id
GROUP BY d.dept_id, d.dept_name;
SELECT * FROM dept_statistics ORDER BY employee_count DESC;

-- 2.3
CREATE VIEW project_overview AS
SELECT p.project_name, p.budget, d.dept_name, d.location,
       (SELECT COUNT(*) FROM employees e WHERE e.dept_id = d.dept_id) AS team_size
FROM projects p
LEFT JOIN departments d ON p.dept_id = d.dept_id;
SELECT * FROM project_overview;

-- 2.4
CREATE VIEW high_earners AS
SELECT e.emp_name, e.salary, d.dept_name
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id
WHERE e.salary > 55000;
SELECT * FROM high_earners;

-- 3.1
CREATE OR REPLACE VIEW employee_details AS
SELECT e.emp_name, e.salary, d.dept_name, d.location,
       CASE WHEN e.salary > 60000 THEN 'High'
            WHEN e.salary > 50000 THEN 'Medium'
            ELSE 'Standard' END AS salary_grade
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id;
SELECT * FROM employee_details;

-- 3.2
ALTER VIEW high_earners RENAME TO top_performers;
SELECT * FROM top_performers;

-- 3.3
CREATE VIEW temp_view AS SELECT * FROM employees WHERE salary < 50000;
SELECT * FROM temp_view;
DROP VIEW temp_view;

-- 4.1
CREATE VIEW employee_salaries AS
SELECT emp_id, emp_name, dept_id, salary FROM employees;

-- 4.2
UPDATE employee_salaries SET salary = 52000 WHERE emp_name = 'John Smith';
SELECT * FROM employees WHERE emp_name = 'John Smith';

-- 4.3
INSERT INTO employee_salaries (emp_id, emp_name, dept_id, salary) VALUES (6,'Alice Johnson',102,58000);
SELECT * FROM employees WHERE emp_id = 6;

-- 4.4
CREATE VIEW it_employees AS
SELECT emp_id, emp_name, dept_id, salary FROM employees WHERE dept_id = 101
WITH LOCAL CHECK OPTION;
INSERT INTO it_employees (emp_id, emp_name, dept_id, salary) VALUES (7,'Bob Wilson',103,60000);

-- 5.1
CREATE MATERIALIZED VIEW dept_summary_mv AS
SELECT d.dept_id, d.dept_name,
       (SELECT COUNT(*) FROM employees e WHERE e.dept_id = d.dept_id) AS total_employees,
       COALESCE((SELECT SUM(e.salary) FROM employees e WHERE e.dept_id = d.dept_id),0) AS total_salaries,
       (SELECT COUNT(*) FROM projects p WHERE p.dept_id = d.dept_id) AS total_projects,
       COALESCE((SELECT SUM(p.budget) FROM projects p WHERE p.dept_id = d.dept_id),0) AS total_project_budget
FROM departments d
WITH DATA;
SELECT * FROM dept_summary_mv ORDER BY total_employees DESC;

-- 5.2
INSERT INTO employees VALUES (8,'Charlie Brown',101,54000);
SELECT * FROM dept_summary_mv ORDER BY total_employees DESC;
REFRESH MATERIALIZED VIEW dept_summary_mv;
SELECT * FROM dept_summary_mv ORDER BY total_employees DESC;

-- 5.3
CREATE UNIQUE INDEX dept_summary_mv_dept_id_idx ON dept_summary_mv (dept_id);
REFRESH MATERIALIZED VIEW CONCURRENTLY dept_summary_mv;

-- 5.4
CREATE MATERIALIZED VIEW project_stats_mv AS
SELECT p.project_name, p.budget, d.dept_name,
       (SELECT COUNT(*) FROM employees e WHERE e.dept_id = p.dept_id) AS assigned_employees
FROM projects p
LEFT JOIN departments d ON p.dept_id = d.dept_id
WITH NO DATA;
SELECT * FROM project_stats_mv;
REFRESH MATERIALIZED VIEW project_stats_mv;
SELECT * FROM project_stats_mv;

-- 6.1
CREATE ROLE analyst NOLOGIN;
CREATE ROLE data_viewer LOGIN PASSWORD 'viewer123';
CREATE ROLE report_user LOGIN PASSWORD 'report456';
SELECT rolname FROM pg_roles WHERE rolname NOT LIKE 'pg_%';

-- 6.2
CREATE ROLE db_creator CREATEDB LOGIN PASSWORD 'creator789';
CREATE ROLE user_manager CREATEROLE LOGIN PASSWORD 'manager101';
CREATE ROLE admin_user SUPERUSER LOGIN PASSWORD 'admin999';

-- 6.3
GRANT SELECT ON employees, departments, projects TO analyst;
GRANT ALL PRIVILEGES ON employee_details TO data_viewer;
GRANT SELECT, INSERT ON employees TO report_user;

-- 6.4
CREATE ROLE hr_team;
CREATE ROLE finance_team;
CREATE ROLE it_team;
CREATE ROLE hr_user1 LOGIN PASSWORD 'hr001';
CREATE ROLE hr_user2 LOGIN PASSWORD 'hr002';
CREATE ROLE finance_user1 LOGIN PASSWORD 'fin001';
GRANT hr_team TO hr_user1, hr_user2;
GRANT finance_team TO finance_user1;
GRANT SELECT, UPDATE ON employees TO hr_team;
GRANT SELECT ON dept_statistics TO finance_team;

-- 6.5
REVOKE UPDATE ON employees FROM hr_team;
REVOKE hr_team FROM hr_user2;
REVOKE ALL PRIVILEGES ON employee_details FROM data_viewer;

-- 6.6
ALTER ROLE analyst WITH LOGIN PASSWORD 'analyst123';
ALTER ROLE user_manager WITH SUPERUSER;
ALTER ROLE analyst WITH PASSWORD NULL;
ALTER ROLE data_viewer WITH CONNECTION LIMIT 5;

-- 7.1
CREATE ROLE read_only;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO read_only;
CREATE ROLE junior_analyst LOGIN PASSWORD 'junior123';
CREATE ROLE senior_analyst LOGIN PASSWORD 'senior123';
GRANT read_only TO junior_analyst, senior_analyst;
GRANT INSERT, UPDATE ON employees TO senior_analyst;

-- 7.2
CREATE ROLE project_manager LOGIN PASSWORD 'pm123';
ALTER VIEW dept_statistics OWNER TO project_manager;
ALTER TABLE projects OWNER TO project_manager;
SELECT tablename, tableowner FROM pg_tables WHERE schemaname = 'public';

-- 7.3
CREATE ROLE temp_owner LOGIN;
CREATE TABLE temp_table (id INT);
ALTER TABLE temp_table OWNER TO temp_owner;
REASSIGN OWNED BY temp_owner TO postgres;
DROP OWNED BY temp_owner;
DROP ROLE temp_owner;

-- 7.4
CREATE VIEW hr_employee_view AS SELECT * FROM employees WHERE dept_id = 102;
GRANT SELECT ON hr_employee_view TO hr_team;
CREATE VIEW finance_employee_view AS SELECT emp_id, emp_name, salary FROM employees;
GRANT SELECT ON finance_employee_view TO finance_team;

-- 8.1
CREATE VIEW dept_dashboard AS
SELECT d.dept_name, d.location,
       COALESCE(e.cnt,0) AS employee_count,
       COALESCE(ROUND(e.avg_sal,2),0) AS avg_salary,
       COALESCE(p.cnt,0) AS active_projects,
       COALESCE(p.total,0) AS total_project_budget,
       CASE WHEN COALESCE(e.cnt,0) = 0 THEN 0
            ELSE ROUND(COALESCE(p.total,0) / e.cnt, 2) END AS budget_per_employee
FROM departments d
LEFT JOIN (SELECT dept_id, COUNT(*) cnt, AVG(salary) avg_sal FROM employees GROUP BY dept_id) e ON e.dept_id = d.dept_id
LEFT JOIN (SELECT dept_id, COUNT(*) cnt, SUM(budget) total FROM projects GROUP BY dept_id) p ON p.dept_id = d.dept_id;
SELECT * FROM dept_dashboard;

-- 8.2
ALTER TABLE projects ADD COLUMN created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
CREATE VIEW high_budget_projects AS
SELECT p.project_name, p.budget, d.dept_name, p.created_date,
       CASE WHEN p.budget > 150000 THEN 'Critical Review Required'
            WHEN p.budget > 100000 THEN 'Management Approval Needed'
            ELSE 'Standard Process' END AS approval_status
FROM projects p
LEFT JOIN departments d ON p.dept_id = d.dept_id
WHERE p.budget > 75000;
SELECT * FROM high_budget_projects;

-- 8.3
CREATE ROLE viewer_role;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO viewer_role;
CREATE ROLE entry_role;
GRANT viewer_role TO entry_role;
GRANT INSERT ON employees, projects TO entry_role;
CREATE ROLE analyst_role;
GRANT entry_role TO analyst_role;
GRANT UPDATE ON employees, projects TO analyst_role;
CREATE ROLE manager_role;
GRANT analyst_role TO manager_role;
GRANT DELETE ON employees, projects TO manager_role;
CREATE ROLE alice LOGIN PASSWORD 'alice123';
CREATE ROLE bob LOGIN PASSWORD 'bob123';
CREATE ROLE charlie LOGIN PASSWORD 'charlie123';
GRANT viewer_role TO alice;
GRANT analyst_role TO bob;
GRANT manager_role TO charlie;

-- ANSWERS
-- 2.1: 4 rows. Tom Brown has dept_id = NULL, so the INNER JOIN excludes him.
-- 2.4: The view returns all employees with salary > 55000 (Jane Doe, Sarah Williams). Yes, all high earners are visible because of the LEFT JOIN.
-- 4.2: Yes, the underlying employees table was updated (simple single-table view is auto-updatable).
-- 4.3: Yes, the insert succeeded; Alice Johnson appears in the employees table.
-- 4.4: ERROR: new row violates check option for view "it_employees". The row has dept_id = 103, which does not satisfy the view condition dept_id = 101.
-- 5.2: Before REFRESH the materialized view still shows old data (without Charlie Brown). After REFRESH the IT department has +1 employee and +54000 in total salaries.
-- 5.3: CONCURRENTLY refreshes without locking the view for reads (SELECT works during the refresh). It requires a unique index.
-- 5.4: ERROR: materialized view "project_stats_mv" has not been populated. Fix: REFRESH MATERIALIZED VIEW project_stats_mv;
