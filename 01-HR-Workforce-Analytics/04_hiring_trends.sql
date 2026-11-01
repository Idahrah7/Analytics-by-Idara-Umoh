-- 1. Annual hiring trends
SELECT
    YEAR(hire_date_clean) AS [Year],
    COUNT(*) AS [Employees Hired]
FROM dbo.vw_HR_Workforce_Cleaned
WHERE hire_date_clean IS NOT NULL
GROUP BY YEAR(hire_date_clean)
ORDER BY [Year];


-- 2. Annual employee terminations
SELECT
    YEAR(termination_date) AS [Year],
    COUNT(*) AS [Employees Terminated]
FROM dbo.vw_HR_Workforce_Cleaned
WHERE termination_date IS NOT NULL
  AND employee_status = 'Terminated'
GROUP BY YEAR(termination_date)
ORDER BY [Year];


-- 3. Annual hiring versus terminations
WITH WorkforceChanges AS (
    SELECT
        YEAR(hire_date_clean) AS [Year],
        COUNT(*) AS [Employees Hired],
        0 AS [Employees Terminated]
    FROM dbo.vw_HR_Workforce_Cleaned
    WHERE hire_date_clean IS NOT NULL
    GROUP BY YEAR(hire_date_clean)

    UNION ALL

    SELECT
        YEAR(termination_date) AS [Year],
        0 AS [Employees Hired],
        COUNT(*) AS [Employees Terminated]
    FROM dbo.vw_HR_Workforce_Cleaned
    WHERE termination_date IS NOT NULL
      AND employee_status = 'Terminated'
    GROUP BY YEAR(termination_date)
)
SELECT
    [Year],
    SUM([Employees Hired]) AS [Total Hired],
    SUM([Employees Terminated]) AS [Total Terminated],
    SUM([Employees Hired]) -
    SUM([Employees Terminated]) AS [Net Workforce Change]
FROM WorkforceChanges
GROUP BY [Year]
ORDER BY [Year];


-- 4. Cumulative workforce growth
WITH WorkforceChanges AS (
    SELECT
        YEAR(hire_date_clean) AS [Year],
        COUNT(*) AS [Employees Hired],
        0 AS [Employees Terminated]
    FROM dbo.vw_HR_Workforce_Cleaned
    WHERE hire_date_clean IS NOT NULL
    GROUP BY YEAR(hire_date_clean)

    UNION ALL

    SELECT
        YEAR(termination_date) AS [Year],
        0 AS [Employees Hired],
        COUNT(*) AS [Employees Terminated]
    FROM dbo.vw_HR_Workforce_Cleaned
    WHERE termination_date IS NOT NULL
      AND employee_status = 'Terminated'
    GROUP BY YEAR(termination_date)
),
AnnualSummary AS (
    SELECT
        [Year],
        SUM([Employees Hired]) AS [Total Hired],
        SUM([Employees Terminated]) AS [Total Terminated]
    FROM WorkforceChanges
    GROUP BY [Year]
)
SELECT
    [Year],
    [Total Hired],
    [Total Terminated],
    [Total Hired] - [Total Terminated]
        AS [Net Workforce Change],
    SUM(
        [Total Hired] - [Total Terminated]
    ) OVER (
        ORDER BY [Year]
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS [Cumulative Workforce Growth]
FROM AnnualSummary
ORDER BY [Year];

-- 5. Employee age at hiring
WITH HiringAge AS (
 SELECT id, hire_date_clean, birth_date,
 DATEDIFF(YEAR, birth_date, hire_date_clean) -
 CASE WHEN DATEADD(YEAR, DATEDIFF(YEAR, birth_date, hire_date_clean), birth_date)
 > hire_date_clean THEN 1 ELSE 0 END AS age_at_hire
 FROM dbo.vw_HR_Workforce_Cleaned
 WHERE birth_date IS NOT NULL AND hire_date_clean IS NOT NULL
 AND hire_date_clean >= birth_date
),
HiringAgeGroups AS (
 SELECT CASE
 WHEN age_at_hire BETWEEN 18 AND 24 THEN '18-24'
 WHEN age_at_hire BETWEEN 25 AND 34 THEN '25-34'
 WHEN age_at_hire BETWEEN 35 AND 44 THEN '35-44'
 WHEN age_at_hire BETWEEN 45 AND 54 THEN '45-54'
 ELSE '55+' END AS [Age Group at Hire]
 FROM HiringAge WHERE age_at_hire >= 18
)
SELECT [Age Group at Hire], COUNT(*) AS [Employees Hired],
 CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS DECIMAL(5,2)) AS [Percentage (%)]
FROM HiringAgeGroups
GROUP BY [Age Group at Hire]
ORDER BY [Employees Hired] DESC;
