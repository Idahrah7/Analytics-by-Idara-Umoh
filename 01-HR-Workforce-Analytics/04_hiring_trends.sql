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
