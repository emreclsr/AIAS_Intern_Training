/* 1- Return all employees who earns the highest salary in each department. (Hint: use analytic functions) */

WITH max_salary_each_department AS 
    (SELECT MAX(salary) AS max_salary, department_id 
    FROM HR_EMPLOYEES 
    GROUP BY department_id) 
SELECT EMP.employee_id, EMP.first_name, EMP.last_name, EMP.department_id, EMP.salary, SAL.max_salary 
FROM HR_EMPLOYEES EMP 
JOIN max_salary_each_department SAL ON EMP.department_id = SAL.department_id 
WHERE EMP.salary = SAL.max_salary 
ORDER BY EMP.department_id 

/* Alternative solution */

WITH MAX_SALARY_FOR_EACH_DEPARTMENT AS
    (SELECT DEPARTMENT_ID, EMPLOYEE_ID, FIRST_NAME, LAST_NAME, 
    MAX(salary) KEEP (DENSE_RANK FIRST ORDER BY salary) OVER (PARTITION BY department_id) MAX_SALARY_FOR_EACH_DEPARTMENT,
    DENSE_RANK() OVER (PARTITION BY DEPARTMENT_ID ORDER BY SALARY) AS DRANK
    FROM HR_EMPLOYEES)
SELECT DEPARTMENT_ID, EMPLOYEE_ID, FIRST_NAME, LAST_NAME, MAX_SALARY_FOR_EACH_DEPARTMENT 
FROM MAX_SALARY_FOR_EACH_DEPARTMENT
WHERE DRANK = 1
