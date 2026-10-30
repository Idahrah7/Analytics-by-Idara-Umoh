-- 1. Employee status by department
WITH DepartmentSummary AS (
    SELECT
        department AS [Department],
        COUNT(*) AS [Total Employees],
        SUM(
            CASE
                WHEN employee_status IN ('Active', 'Pending Termination')
                THEN 1 ELSE 0
            END
        ) AS [Current Employees],
        SUM(
            CASE
                WHEN employee_status = 'Pending Termination'
                THEN 1 ELSE 0
            END
        ) AS [On Notice],
        SUM(
            CASE
                WHEN employee_status = 'Terminated'
                THEN 1 ELSE 0
            END
        ) AS [Former Employees]
    FROM dbo.vw_HR_Workforce_Cleaned
    GROUP BY department
)
SELECT
    [Department],
    [Total Employees],
    [Current Employees],
    [On Notice],
    [Former Employees]
FROM DepartmentSummary
ORDER BY [Former Employees] DESC;


-- 2. Former employee proportion by department
WITH DepartmentSummary AS (
    SELECT
        department AS [Department],
        COUNT(*) AS [Total Employees],
        SUM(
            CASE
                WHEN employee_status IN ('Active', 'Pending Termination')
                THEN 1 ELSE 0
            END
        ) AS [Current Employees],
        SUM(
            CASE
                WHEN employee_status = 'Pending Termination'
                THEN 1 ELSE 0
            END
        ) AS [On Notice],
        SUM(
            CASE
                WHEN employee_status = 'Terminated'
                THEN 1 ELSE 0
            END
        ) AS [Former Employees]
    FROM dbo.vw_HR_Workforce_Cleaned
    GROUP BY department
)
SELECT
    [Department],
    [Total Employees],
    [Current Employees],
    [On Notice],
    [Former Employees],
    CAST(
        [Former Employees] * 100.0 /
        NULLIF([Total Employees], 0)
        AS DECIMAL(5,2)
    ) AS [Former Employee Percentage]
FROM DepartmentSummary
ORDER BY [Former Employee Percentage] DESC;


-- 3. Average tenure of former employees
SELECT
    CAST(
        AVG(
            DATEDIFF(
                DAY,
                hire_date_clean,
                termination_date
            ) * 1.0
        ) / 365.25
        AS DECIMAL(10,2)
    ) AS [Average Tenure (Years)]
FROM dbo.vw_HR_Workforce_Cleaned
WHERE employee_status = 'Terminated'
  AND hire_date_clean IS NOT NULL
  AND termination_date IS NOT NULL
  AND termination_date >= hire_date_clean;


-- 4. Average tenure of former employees by department
SELECT
    department AS [Department],
    COUNT(*) AS [Former Employees],
    CAST(
        AVG(
            DATEDIFF(
                DAY,
                hire_date_clean,
                termination_date
            ) * 1.0
        ) / 365.25
        AS DECIMAL(10,2)
    ) AS [Average Tenure (Years)]
FROM dbo.vw_HR_Workforce_Cleaned
WHERE employee_status = 'Terminated'
  AND hire_date_clean IS NOT NULL
  AND termination_date IS NOT NULL
  AND termination_date >= hire_date_clean
GROUP BY department
ORDER BY [Average Tenure (Years)] DESC;
