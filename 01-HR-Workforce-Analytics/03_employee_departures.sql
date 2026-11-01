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

-- 5. Average, shortest and longest tenure by department
SELECT department AS [Department], COUNT(*) AS [Former Employees],
 CAST(AVG(DATEDIFF(DAY, hire_date_clean, termination_date) * 1.0) / 365.25 AS DECIMAL(10,2)) AS [Average Tenure (Years)],
 CAST(MIN(DATEDIFF(DAY, hire_date_clean, termination_date) * 1.0) / 365.25 AS DECIMAL(10,2)) AS [Shortest Tenure (Years)],
 CAST(MAX(DATEDIFF(DAY, hire_date_clean, termination_date) * 1.0) / 365.25 AS DECIMAL(10,2)) AS [Longest Tenure (Years)]
FROM dbo.vw_HR_Workforce_Cleaned
WHERE employee_status = 'Terminated'
 AND hire_date_clean IS NOT NULL AND termination_date >= hire_date_clean
GROUP BY department
ORDER BY [Average Tenure (Years)] DESC;

-- 6. Tenure groups of former employees
WITH Tenure AS (
 SELECT DATEDIFF(DAY, hire_date_clean, termination_date) / 365.25 AS tenure_years
 FROM dbo.vw_HR_Workforce_Cleaned
 WHERE employee_status = 'Terminated'
 AND hire_date_clean IS NOT NULL AND termination_date >= hire_date_clean
),
TenureGroups AS (
 SELECT CASE WHEN tenure_years < 3 THEN '0-2 Years'
 WHEN tenure_years < 6 THEN '3-5 Years'
 WHEN tenure_years < 11 THEN '6-10 Years'
 WHEN tenure_years < 16 THEN '11-15 Years'
 ELSE '16+ Years' END AS [Tenure Group]
 FROM Tenure
)
SELECT [Tenure Group], COUNT(*) AS [Employees],
 CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS DECIMAL(5,2)) AS [Percentage (%)]
FROM TenureGroups
GROUP BY [Tenure Group]
ORDER BY CASE [Tenure Group]
 WHEN '0-2 Years' THEN 1 WHEN '3-5 Years' THEN 2
 WHEN '6-10 Years' THEN 3 WHEN '11-15 Years' THEN 4 ELSE 5 END;

-- 7. Former employees by location
SELECT location AS [Location], COUNT(*) AS [Former Employees],
 CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS DECIMAL(5,2)) AS [Percentage (%)]
FROM dbo.vw_HR_Workforce_Cleaned
WHERE employee_status = 'Terminated'
GROUP BY location
ORDER BY [Former Employees] DESC;

-- 8. Employees pending termination by location
SELECT location AS [Location], COUNT(*) AS [On Notice Employees],
 CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS DECIMAL(5,2)) AS [Percentage (%)]
FROM dbo.vw_HR_Workforce_Cleaned
WHERE employee_status = 'Pending Termination'
GROUP BY location
ORDER BY [On Notice Employees] DESC;

-- 9. Former employee proportion by location
SELECT location AS [Location], COUNT(*) AS [Total Employees],
 SUM(CASE WHEN employee_status = 'Terminated' THEN 1 ELSE 0 END) AS [Former Employees],
 SUM(CASE WHEN employee_status IN ('Active', 'Pending Termination') THEN 1 ELSE 0 END) AS [Current Employees],
 CAST(SUM(CASE WHEN employee_status = 'Terminated' THEN 1 ELSE 0 END) * 100.0 /
 NULLIF(COUNT(*), 0) AS DECIMAL(5,2)) AS [Former Employee Percentage]
FROM dbo.vw_HR_Workforce_Cleaned
GROUP BY location
ORDER BY [Former Employee Percentage] DESC;

-- 10. Gender distribution of former employees by location
SELECT location AS [Location],
 SUM(CASE WHEN gender = 'Male' THEN 1 ELSE 0 END) AS [Male],
 SUM(CASE WHEN gender = 'Female' THEN 1 ELSE 0 END) AS [Female],
 COUNT(*) AS [Total Former Employees],
 CAST(SUM(CASE WHEN gender = 'Male' THEN 1 ELSE 0 END) * 100.0 /
 NULLIF(COUNT(*), 0) AS DECIMAL(5,2)) AS [Male (%)],
 CAST(SUM(CASE WHEN gender = 'Female' THEN 1 ELSE 0 END) * 100.0 /
 NULLIF(COUNT(*), 0) AS DECIMAL(5,2)) AS [Female (%)]
FROM dbo.vw_HR_Workforce_Cleaned
WHERE employee_status = 'Terminated'
GROUP BY location
ORDER BY location;
