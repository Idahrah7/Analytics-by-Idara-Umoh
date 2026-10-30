-- 1. Current workforce by gender
SELECT
    gender AS [Gender],
    COUNT(*) AS [Employee Count]
FROM dbo.vw_HR_Workforce_Cleaned
WHERE employee_status IN ('Active', 'Pending Termination')
GROUP BY gender
ORDER BY [Employee Count] DESC;


-- 2. Gender distribution across all employee records
SELECT
    gender AS [Gender],
    COUNT(*) AS [Employee Count],
    CAST(
        COUNT(*) * 100.0 /
        NULLIF(
            (SELECT COUNT(*) FROM dbo.vw_HR_Workforce_Cleaned),
            0
        ) AS DECIMAL(5,2)
    ) AS [Percentage of Total Employees]
FROM dbo.vw_HR_Workforce_Cleaned
GROUP BY gender
ORDER BY [Employee Count] DESC;


-- 3. Current workforce by race
SELECT
    race AS [Race],
    COUNT(*) AS [Employee Count]
FROM dbo.vw_HR_Workforce_Cleaned
WHERE employee_status IN ('Active', 'Pending Termination')
GROUP BY race
ORDER BY [Employee Count] DESC;


-- 4. Race distribution across all employee records
SELECT
    race AS [Race],
    COUNT(*) AS [Employee Count],
    CAST(
        COUNT(*) * 100.0 /
        NULLIF(
            (SELECT COUNT(*) FROM dbo.vw_HR_Workforce_Cleaned),
            0
        ) AS DECIMAL(5,2)
    ) AS [Percentage of Total Employees]
FROM dbo.vw_HR_Workforce_Cleaned
GROUP BY race
ORDER BY [Employee Count] DESC;


-- 5. Current workforce by age group
WITH AgeGroups AS (
    SELECT
        CASE
            WHEN age BETWEEN 18 AND 24 THEN '18-24'
            WHEN age BETWEEN 25 AND 34 THEN '25-34'
            WHEN age BETWEEN 35 AND 44 THEN '35-44'
            WHEN age BETWEEN 45 AND 54 THEN '45-54'
            WHEN age >= 55 THEN '55+'
            ELSE 'Unknown'
        END AS [Age Group]
    FROM dbo.vw_HR_Workforce_Cleaned
    WHERE employee_status IN ('Active', 'Pending Termination')
)
SELECT
    [Age Group],
    COUNT(*) AS [Employee Count]
FROM AgeGroups
GROUP BY [Age Group]
ORDER BY [Employee Count] DESC;


-- 6. Current workforce by department
SELECT
    department AS [Department],
    COUNT(*) AS [Employee Count]
FROM dbo.vw_HR_Workforce_Cleaned
WHERE employee_status IN ('Active', 'Pending Termination')
GROUP BY department
ORDER BY [Employee Count] DESC;


-- 7. Current workforce by job title
SELECT
    jobtitle AS [Job Title],
    COUNT(*) AS [Employee Count]
FROM dbo.vw_HR_Workforce_Cleaned
WHERE employee_status IN ('Active', 'Pending Termination')
GROUP BY jobtitle
ORDER BY [Employee Count] DESC;


-- 8. Number of distinct job titles
SELECT
    COUNT(DISTINCT jobtitle) AS [Number of Job Titles]
FROM dbo.vw_HR_Workforce_Cleaned;


-- 9. Current workforce by location
SELECT
    location AS [Location],
    COUNT(*) AS [Employee Count]
FROM dbo.vw_HR_Workforce_Cleaned
WHERE employee_status IN ('Active', 'Pending Termination')
GROUP BY location
ORDER BY [Employee Count] DESC;


-- 10. Current workforce by department and gender
SELECT
    department AS [Department],
    gender AS [Gender],
    COUNT(*) AS [Employee Count]
FROM dbo.vw_HR_Workforce_Cleaned
WHERE employee_status IN ('Active', 'Pending Termination')
GROUP BY department, gender
ORDER BY department, [Employee Count] DESC;


-- 11. Department ranking by current workforce
SELECT
    department AS [Department],
    COUNT(*) AS [Employee Count],
    RANK() OVER (
        ORDER BY COUNT(*) DESC
    ) AS [Department Rank]
FROM dbo.vw_HR_Workforce_Cleaned
WHERE employee_status IN ('Active', 'Pending Termination')
GROUP BY department
ORDER BY [Department Rank];
