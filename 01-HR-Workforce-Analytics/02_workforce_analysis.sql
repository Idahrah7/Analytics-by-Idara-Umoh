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

-- 12. Current workforce by department with percentages
SELECT department AS [Department], COUNT(*) AS [Employee Count],
 CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS DECIMAL(5,2)) AS [Percentage (%)]
FROM dbo.vw_HR_Workforce_Cleaned
WHERE employee_status IN ('Active', 'Pending Termination')
GROUP BY department
ORDER BY [Employee Count] DESC;

-- 13. Current workforce by job title with percentages
SELECT jobtitle AS [Job Title], COUNT(*) AS [Employee Count],
 CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS DECIMAL(5,2)) AS [Percentage (%)]
FROM dbo.vw_HR_Workforce_Cleaned
WHERE employee_status IN ('Active', 'Pending Termination')
GROUP BY jobtitle
ORDER BY [Employee Count] DESC;

-- 14. Distinct job titles
SELECT DISTINCT jobtitle AS [Job Title]
FROM dbo.vw_HR_Workforce_Cleaned
WHERE jobtitle IS NOT NULL
ORDER BY [Job Title];

-- 15. Analyst roles across departments
SELECT department AS [Department],
 COUNT(DISTINCT jobtitle) AS [Distinct Analyst Job Titles],
 COUNT(*) AS [Employees in Analyst Roles],
 CAST(COUNT(*) * 100.0 /
 NULLIF((SELECT COUNT(*) FROM dbo.vw_HR_Workforce_Cleaned
 WHERE employee_status IN ('Active', 'Pending Termination')), 0)
 AS DECIMAL(5,2)) AS [Percentage of Current Workforce]
FROM dbo.vw_HR_Workforce_Cleaned
WHERE jobtitle LIKE '%Analyst%'
 AND employee_status IN ('Active', 'Pending Termination')
GROUP BY department
ORDER BY [Employees in Analyst Roles] DESC;

-- 16. Common job families by department
SELECT department AS [Department],
 SUM(CASE WHEN jobtitle LIKE '%Analyst%' THEN 1 ELSE 0 END) AS [Analysts],
 SUM(CASE WHEN jobtitle LIKE '%Engineer%' THEN 1 ELSE 0 END) AS [Engineers],
 SUM(CASE WHEN jobtitle LIKE '%Manager%' THEN 1 ELSE 0 END) AS [Managers],
 SUM(CASE WHEN jobtitle LIKE '%Developer%' OR jobtitle LIKE '%Programmer%' THEN 1 ELSE 0 END) AS [Developers and Programmers],
 SUM(CASE WHEN jobtitle LIKE '%Accountant%' THEN 1 ELSE 0 END) AS [Accountants]
FROM dbo.vw_HR_Workforce_Cleaned
WHERE employee_status IN ('Active', 'Pending Termination')
GROUP BY department
ORDER BY department;

-- 17. Current workforce distribution by location
SELECT location AS [Location], COUNT(*) AS [Employee Count],
 CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS DECIMAL(5,2)) AS [Percentage (%)]
FROM dbo.vw_HR_Workforce_Cleaned
WHERE employee_status IN ('Active', 'Pending Termination')
GROUP BY location
ORDER BY [Employee Count] DESC;

-- 18. Remote and headquarters employees by department
SELECT department AS [Department],
 SUM(CASE WHEN location = 'Remote' THEN 1 ELSE 0 END) AS [Remote],
 SUM(CASE WHEN location = 'Headquarters' THEN 1 ELSE 0 END) AS [Headquarters],
 COUNT(*) AS [Total Employees],
 CAST(SUM(CASE WHEN location = 'Remote' THEN 1 ELSE 0 END) * 100.0 /
 NULLIF(COUNT(*), 0) AS DECIMAL(5,2)) AS [Remote (%)]
FROM dbo.vw_HR_Workforce_Cleaned
WHERE employee_status IN ('Active', 'Pending Termination')
GROUP BY department
ORDER BY [Remote (%)] DESC;

-- 19. Remote and headquarters employees by gender
SELECT gender AS [Gender],
 SUM(CASE WHEN location = 'Remote' THEN 1 ELSE 0 END) AS [Remote],
 SUM(CASE WHEN location = 'Headquarters' THEN 1 ELSE 0 END) AS [Headquarters],
 COUNT(*) AS [Total Employees],
 CAST(SUM(CASE WHEN location = 'Remote' THEN 1 ELSE 0 END) * 100.0 /
 NULLIF(COUNT(*), 0) AS DECIMAL(5,2)) AS [Remote (%)],
 CAST(SUM(CASE WHEN location = 'Headquarters' THEN 1 ELSE 0 END) * 100.0 /
 NULLIF(COUNT(*), 0) AS DECIMAL(5,2)) AS [Headquarters (%)]
FROM dbo.vw_HR_Workforce_Cleaned
WHERE employee_status IN ('Active', 'Pending Termination')
GROUP BY gender
ORDER BY [Remote (%)] DESC;
