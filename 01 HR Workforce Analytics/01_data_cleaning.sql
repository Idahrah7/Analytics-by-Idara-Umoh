-- 1. Inspect the original HR data
SELECT * FROM [HR Data];

SELECT id, COUNT(*) AS Duplicate_Count
FROM [HR Data]
GROUP BY id
HAVING COUNT(*) > 1;


-- 2. Clean termination dates in the original table
IF COL_LENGTH('dbo.HR Data', 'termdate_clean') IS NULL
    ALTER TABLE [HR Data] ADD termdate_clean DATE;
GO

UPDATE [HR Data]
SET termdate_clean = TRY_CONVERT(DATE, LEFT(NULLIF(LTRIM(RTRIM(termdate)), ''), 10), 120);


-- 3. Calculate employee ages using today's date
IF COL_LENGTH('dbo.HR Data', 'age') IS NULL
    ALTER TABLE [HR Data] ADD age INT;
GO

UPDATE [HR Data]
SET age =
    CASE
        WHEN TRY_CONVERT(DATE, birthdate) IS NULL
          OR TRY_CONVERT(DATE, birthdate) > CAST(GETDATE() AS DATE)
        THEN NULL
        ELSE
            DATEDIFF(YEAR, TRY_CONVERT(DATE, birthdate), GETDATE())
            - CASE
                WHEN DATEADD(
                    YEAR,
                    DATEDIFF(YEAR, TRY_CONVERT(DATE, birthdate), GETDATE()),
                    TRY_CONVERT(DATE, birthdate)
                ) > GETDATE()
                THEN 1 ELSE 0
              END
    END;


-- 4. Classify employees based on termination dates
IF COL_LENGTH('dbo.HR Data', 'Employee Status') IS NULL
    ALTER TABLE [HR Data] ADD [Employee Status] VARCHAR(20);
GO

UPDATE [HR Data]
SET [Employee Status] =
    CASE
        WHEN NULLIF(LTRIM(RTRIM(termdate)), '') IS NULL THEN 'Active'
        WHEN termdate_clean IS NULL THEN 'Unknown'
        WHEN termdate_clean > CAST(GETDATE() AS DATE) THEN 'Pending Termination'
        ELSE 'Terminated'
    END;


-- 5. Create the cleaned HR table with the original column names
-- This table is a derived copy of [HR Data].
IF OBJECT_ID('dbo.[Cleaned HR Data]', 'U') IS NULL
BEGIN
    SELECT TOP (0)
        id AS ID,
        first_name AS [First Name],
        last_name AS [Last Name],
        TRY_CONVERT(DATE, birthdate) AS [Birth Date],
        gender AS Gender,
        race AS Race,
        department AS Department,
        jobtitle AS [Job Title],
        TRY_CONVERT(DATE, hire_date) AS [Hire Date],
        location AS Location,
        termdate_clean AS [Termination Date],
        age AS Age,
        [Employee Status]
    INTO [Cleaned HR Data]
    FROM [HR Data];
END;
GO

-- Refresh only the derived columns/rows in the cleaned copy.
-- Run this after the source-table cleaning steps above.
DELETE FROM [Cleaned HR Data];

INSERT INTO [Cleaned HR Data] (
    ID, [First Name], [Last Name], [Birth Date],
    Gender, Race, Department, [Job Title],
    [Hire Date], Location, [Termination Date], Age, [Employee Status]
)
SELECT
    id,
    first_name,
    last_name,
    TRY_CONVERT(DATE, birthdate),
    gender,
    race,
    department,
    jobtitle,
    TRY_CONVERT(DATE, hire_date),
    location,
    termdate_clean,
    age,
    [Employee Status]
FROM [HR Data];


-- 6. Check the cleaned table
SELECT COUNT(*) AS [Total Employees]
FROM [Cleaned HR Data];

SELECT [Employee Status], COUNT(*) AS [Employee Count]
FROM [Cleaned HR Data]
GROUP BY [Employee Status]
ORDER BY [Employee Count] DESC;

SELECT MIN(Age) AS youngest, MAX(Age) AS oldest
FROM [Cleaned HR Data];

SELECT
    SUM(CASE WHEN [Birth Date] > CAST(GETDATE() AS DATE) THEN 1 ELSE 0 END)
        AS [Future Birth Dates],
    SUM(CASE WHEN [Hire Date] < [Birth Date] THEN 1 ELSE 0 END)
        AS [Hired Before Birth]
FROM [Cleaned HR Data];
