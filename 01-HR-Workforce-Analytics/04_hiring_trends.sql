-- 1. Annual hiring trends
SELECT
    YEAR([Hire Date]) AS [Year],
    COUNT(*) AS [Employees Hired]
FROM [Cleaned HR Data]
WHERE [Hire Date] IS NOT NULL
  AND [Hire Date] <= CAST(GETDATE() AS DATE)
GROUP BY YEAR([Hire Date])
ORDER BY [Year];


-- 2. Annual employee terminations
SELECT
    YEAR([Termination Date]) AS [Year],
    COUNT(*) AS [Employees Terminated]
FROM [Cleaned HR Data]
WHERE [Termination Date] IS NOT NULL
  AND [Employee Status] = 'Terminated'
GROUP BY YEAR([Termination Date])
ORDER BY [Year];


-- 3. Annual hiring versus terminations
WITH WorkforceChanges AS (
    SELECT
        YEAR([Hire Date]) AS [Year],
        COUNT(*) AS [Employees Hired],
        0 AS [Employees Terminated]
    FROM [Cleaned HR Data]
    WHERE [Hire Date] IS NOT NULL
  AND [Hire Date] <= CAST(GETDATE() AS DATE)
    GROUP BY YEAR([Hire Date])

    UNION ALL

    SELECT
        YEAR([Termination Date]) AS [Year],
        0 AS [Employees Hired],
        COUNT(*) AS [Employees Terminated]
    FROM [Cleaned HR Data]
    WHERE [Termination Date] IS NOT NULL
      AND [Employee Status] = 'Terminated'
    GROUP BY YEAR([Termination Date])
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
        YEAR([Hire Date]) AS [Year],
        COUNT(*) AS [Employees Hired],
        0 AS [Employees Terminated]
    FROM [Cleaned HR Data]
    WHERE [Hire Date] IS NOT NULL
  AND [Hire Date] <= CAST(GETDATE() AS DATE)
    GROUP BY YEAR([Hire Date])

    UNION ALL

    SELECT
        YEAR([Termination Date]) AS [Year],
        0 AS [Employees Hired],
        COUNT(*) AS [Employees Terminated]
    FROM [Cleaned HR Data]
    WHERE [Termination Date] IS NOT NULL
      AND [Employee Status] = 'Terminated'
    GROUP BY YEAR([Termination Date])
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
    SELECT
        id,
        [Hire Date],
        [Birth Date],
        DATEDIFF(YEAR, [Birth Date], [Hire Date])
        -
        CASE
            WHEN DATEADD(
                YEAR,
                DATEDIFF(YEAR, [Birth Date], [Hire Date]),
                [Birth Date]
            ) > [Hire Date]
            THEN 1 ELSE 0
        END AS age_at_hire
    FROM [Cleaned HR Data]
    WHERE [Birth Date] IS NOT NULL
      AND [Hire Date] IS NOT NULL
      AND [Hire Date] >= [Birth Date]
      AND [Hire Date] <= CAST(GETDATE() AS DATE)
),
HiringAgeGroups AS (
    SELECT
        CASE
            WHEN age_at_hire BETWEEN 18 AND 24 THEN '18-24'
            WHEN age_at_hire BETWEEN 25 AND 34 THEN '25-34'
            WHEN age_at_hire BETWEEN 35 AND 44 THEN '35-44'
            WHEN age_at_hire BETWEEN 45 AND 54 THEN '45-54'
            ELSE '55+'
        END AS [Age Group at Hire]
    FROM HiringAge
    WHERE age_at_hire >= 18
)
SELECT
    [Age Group at Hire],
    COUNT(*) AS [Employees Hired],
    CAST(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER ()
        AS DECIMAL(5,2)
    ) AS [Percentage (%)]
FROM HiringAgeGroups
GROUP BY [Age Group at Hire]
ORDER BY [Employees Hired] DESC;

-- 6. Annual hiring by department
SELECT
    YEAR([Hire Date]) AS [Year],
    department AS [Department],
    COUNT(*) AS [Employees Hired]
FROM [Cleaned HR Data]
WHERE [Hire Date] IS NOT NULL
  AND [Hire Date] <= CAST(GETDATE() AS DATE)
GROUP BY
    YEAR([Hire Date]),
    department
ORDER BY
    [Year],
    [Employees Hired] DESC;


-- 7. Annual employee departures by department
SELECT
    YEAR([Termination Date]) AS [Year],
    department AS [Department],
    COUNT(*) AS [Employees Terminated]
FROM [Cleaned HR Data]
WHERE [Employee Status] = 'Terminated'
  AND [Termination Date] IS NOT NULL
GROUP BY
    YEAR([Termination Date]),
    department
ORDER BY
    [Year],
    [Employees Terminated] DESC;


-- 8. Annual net workforce change by department
WITH WorkforceChanges AS (
    SELECT
        YEAR([Hire Date]) AS [Year],
        department AS [Department],
        COUNT(*) AS [Employees Hired],
        0 AS [Employees Terminated]
    FROM [Cleaned HR Data]
    WHERE [Hire Date] IS NOT NULL
      AND [Hire Date] <= CAST(GETDATE() AS DATE)
    GROUP BY
        YEAR([Hire Date]),
        department

    UNION ALL

    SELECT
        YEAR([Termination Date]) AS [Year],
        department AS [Department],
        0 AS [Employees Hired],
        COUNT(*) AS [Employees Terminated]
    FROM [Cleaned HR Data]
    WHERE [Employee Status] = 'Terminated'
      AND [Termination Date] IS NOT NULL
    GROUP BY
        YEAR([Termination Date]),
        department
),
AnnualSummary AS (
    SELECT
        [Year],
        [Department],
        SUM([Employees Hired]) AS [Total Hired],
        SUM([Employees Terminated]) AS [Total Terminated]
    FROM WorkforceChanges
    GROUP BY
        [Year],
        [Department]
)
SELECT
    [Year],
    [Department],
    [Total Hired],
    [Total Terminated],

    [Total Hired] - [Total Terminated]
        AS [Net Workforce Change],

    SUM(
        [Total Hired] - [Total Terminated]
    ) OVER (
        PARTITION BY [Department]
        ORDER BY [Year]
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS [Cumulative Department Growth]

FROM AnnualSummary
ORDER BY
    [Department],
    [Year];
