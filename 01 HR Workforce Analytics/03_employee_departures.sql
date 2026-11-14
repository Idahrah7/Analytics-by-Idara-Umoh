-- 1. Employee status by department
WITH DepartmentSummary AS (
    SELECT
        department AS [Department],
        COUNT(*) AS [Total Employees],
        SUM(
            CASE
                WHEN [Employee Status] IN ('Active', 'Pending Termination')
                THEN 1 ELSE 0
            END
        ) AS [Current Employees],
        SUM(
            CASE
                WHEN [Employee Status] = 'Pending Termination'
                THEN 1 ELSE 0
            END
        ) AS [On Notice],
        SUM(
            CASE
                WHEN [Employee Status] = 'Terminated'
                THEN 1 ELSE 0
            END
        ) AS [Former Employees]
    FROM [Cleaned HR Data]
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
                WHEN [Employee Status] IN ('Active', 'Pending Termination')
                THEN 1 ELSE 0
            END
        ) AS [Current Employees],
        SUM(
            CASE
                WHEN [Employee Status] = 'Pending Termination'
                THEN 1 ELSE 0
            END
        ) AS [On Notice],
        SUM(
            CASE
                WHEN [Employee Status] = 'Terminated'
                THEN 1 ELSE 0
            END
        ) AS [Former Employees]
    FROM [Cleaned HR Data]
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
                [Hire Date],
                [Termination Date]
            ) * 1.0
        ) / 365.25
        AS DECIMAL(10,2)
    ) AS [Average Tenure (Years)]
FROM [Cleaned HR Data]
WHERE [Employee Status] = 'Terminated'
  AND [Hire Date] IS NOT NULL
  AND [Termination Date] IS NOT NULL
  AND [Termination Date] >= [Hire Date];


-- 4. Average tenure of former employees by department
SELECT
    department AS [Department],
    COUNT(*) AS [Former Employees],
    CAST(
        AVG(
            DATEDIFF(
                DAY,
                [Hire Date],
                [Termination Date]
            ) * 1.0
        ) / 365.25
        AS DECIMAL(10,2)
    ) AS [Average Tenure (Years)]
FROM [Cleaned HR Data]
WHERE [Employee Status] = 'Terminated'
  AND [Hire Date] IS NOT NULL
  AND [Termination Date] IS NOT NULL
  AND [Termination Date] >= [Hire Date]
GROUP BY department
ORDER BY [Average Tenure (Years)] DESC;

-- 5. Average, shortest and longest tenure by department
SELECT department AS [Department], COUNT(*) AS [Former Employees],
 CAST(AVG(DATEDIFF(DAY, [Hire Date], [Termination Date]) * 1.0) / 365.25 AS DECIMAL(10,2)) AS [Average Tenure (Years)],
 CAST(MIN(DATEDIFF(DAY, [Hire Date], [Termination Date]) * 1.0) / 365.25 AS DECIMAL(10,2)) AS [Shortest Tenure (Years)],
 CAST(MAX(DATEDIFF(DAY, [Hire Date], [Termination Date]) * 1.0) / 365.25 AS DECIMAL(10,2)) AS [Longest Tenure (Years)]
FROM [Cleaned HR Data]
WHERE [Employee Status] = 'Terminated'
 AND [Hire Date] IS NOT NULL AND [Termination Date] >= [Hire Date]
GROUP BY department
ORDER BY [Average Tenure (Years)] DESC;

-- 6. Tenure groups of former employees
WITH Tenure AS (
 SELECT DATEDIFF(DAY, [Hire Date], [Termination Date]) / 365.25 AS tenure_years
 FROM [Cleaned HR Data]
 WHERE [Employee Status] = 'Terminated'
 AND [Hire Date] IS NOT NULL AND [Termination Date] >= [Hire Date]
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
FROM [Cleaned HR Data]
WHERE [Employee Status] = 'Terminated'
GROUP BY location
ORDER BY [Former Employees] DESC;

-- 8. Employees pending termination by location
SELECT location AS [Location], COUNT(*) AS [On Notice Employees],
 CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS DECIMAL(5,2)) AS [Percentage (%)]
FROM [Cleaned HR Data]
WHERE [Employee Status] = 'Pending Termination'
GROUP BY location
ORDER BY [On Notice Employees] DESC;

-- 9. Former employee proportion by location
SELECT location AS [Location], COUNT(*) AS [Total Employees],
 SUM(CASE WHEN [Employee Status] = 'Terminated' THEN 1 ELSE 0 END) AS [Former Employees],
 SUM(CASE WHEN [Employee Status] IN ('Active', 'Pending Termination') THEN 1 ELSE 0 END) AS [Current Employees],
 CAST(SUM(CASE WHEN [Employee Status] = 'Terminated' THEN 1 ELSE 0 END) * 100.0 /
 NULLIF(COUNT(*), 0) AS DECIMAL(5,2)) AS [Former Employee Percentage]
FROM [Cleaned HR Data]
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
FROM [Cleaned HR Data]
WHERE [Employee Status] = 'Terminated'
GROUP BY location
ORDER BY location;

-- 11. Department retention comparison
WITH DepartmentSummary AS (
    SELECT
        department AS [Department],
        COUNT(*) AS [Total Employees],
        SUM(CASE
            WHEN [Employee Status] IN ('Active', 'Pending Termination')
            THEN 1 ELSE 0
        END) AS [Current Employees],
        SUM(CASE
            WHEN [Employee Status] = 'Terminated'
            THEN 1 ELSE 0
        END) AS [Former Employees]
    FROM [Cleaned HR Data]
    GROUP BY department
)
SELECT
    [Department],
    [Total Employees],
    [Current Employees],
    [Former Employees],
    CAST(
        [Current Employees] * 100.0 /
        NULLIF([Total Employees], 0)
        AS DECIMAL(5,2)
    ) AS [Current Employee Percentage],
    CAST(
        [Former Employees] * 100.0 /
        NULLIF([Total Employees], 0)
        AS DECIMAL(5,2)
    ) AS [Former Employee Percentage]
FROM DepartmentSummary
ORDER BY [Former Employee Percentage] DESC;


-- 12. Age at departure
WITH DepartureAge AS (
    SELECT
        id,
        department,
        [Birth Date],
        [Termination Date],
        DATEDIFF(YEAR, [Birth Date], [Termination Date])
        -
        CASE
            WHEN DATEADD(
                YEAR,
                DATEDIFF(YEAR, [Birth Date], [Termination Date]),
                [Birth Date]
            ) > [Termination Date]
            THEN 1 ELSE 0
        END AS age_at_departure
    FROM [Cleaned HR Data]
    WHERE [Employee Status] = 'Terminated'
      AND [Birth Date] IS NOT NULL
      AND [Termination Date] IS NOT NULL
      AND [Birth Date] <= CAST(GETDATE() AS DATE)
      AND [Termination Date] >= [Birth Date]
      AND [Termination Date] <= CAST(GETDATE() AS DATE)
)
SELECT
    department AS [Department],
    COUNT(*) AS [Former Employees],
    CAST(
        AVG(age_at_departure * 1.0)
        AS DECIMAL(5,2)
    ) AS [Average Age at Departure],
    MIN(age_at_departure) AS [Youngest Departure Age],
    MAX(age_at_departure) AS [Oldest Departure Age]
FROM DepartureAge
WHERE age_at_departure >= 18
GROUP BY department
ORDER BY [Average Age at Departure] DESC;


-- 13. Departures by age group
WITH DepartureAge AS (
    SELECT
        DATEDIFF(YEAR, [Birth Date], [Termination Date])
        -
        CASE
            WHEN DATEADD(
                YEAR,
                DATEDIFF(YEAR, [Birth Date], [Termination Date]),
                [Birth Date]
            ) > [Termination Date]
            THEN 1 ELSE 0
        END AS age_at_departure
    FROM [Cleaned HR Data]
    WHERE [Employee Status] = 'Terminated'
      AND [Birth Date] IS NOT NULL
      AND [Termination Date] IS NOT NULL
      AND [Birth Date] <= CAST(GETDATE() AS DATE)
      AND [Termination Date] >= [Birth Date]
      AND [Termination Date] <= CAST(GETDATE() AS DATE)
),
AgeGroups AS (
    SELECT
        CASE
            WHEN age_at_departure BETWEEN 18 AND 24 THEN '18-24'
            WHEN age_at_departure BETWEEN 25 AND 34 THEN '25-34'
            WHEN age_at_departure BETWEEN 35 AND 44 THEN '35-44'
            WHEN age_at_departure BETWEEN 45 AND 54 THEN '45-54'
            ELSE '55+'
        END AS [Departure Age Group]
    FROM DepartureAge
    WHERE age_at_departure >= 18
)
SELECT
    [Departure Age Group],
    COUNT(*) AS [Former Employees],
    CAST(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER ()
        AS DECIMAL(5,2)
    ) AS [Percentage of Departures]
FROM AgeGroups
GROUP BY [Departure Age Group]
ORDER BY [Former Employees] DESC;
