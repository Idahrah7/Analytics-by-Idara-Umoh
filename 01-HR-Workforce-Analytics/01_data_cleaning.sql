-- 1. Inspect source records and check for duplicate employee IDs.
SELECT COUNT(*) AS total_records,
       COUNT(DISTINCT id) AS distinct_employee_ids
FROM [HR Data];

SELECT id, COUNT(*) AS occurrences
FROM [HR Data]
GROUP BY id
HAVING COUNT(*) > 1;

-- 2. Create the cleaned HR data view.
-- Date conversions use US month/day/year formats for birth/hire dates;
-- termination timestamps begin with ISO yyyy-mm-dd.
GO
CREATE OR ALTER VIEW dbo.vw_HR_Workforce_Cleaned
AS
WITH ParsedDates AS (
    SELECT
        id,
        gender,
        race,
        department,
        jobtitle,
        location,
        location_city,
        location_state,
        COALESCE(
            TRY_CONVERT(date, NULLIF(LTRIM(RTRIM(CONVERT(varchar(50), birthdate))), ''), 101),
            TRY_CONVERT(date, NULLIF(LTRIM(RTRIM(CONVERT(varchar(50), birthdate))), ''), 110)
        ) AS birth_date,
        COALESCE(
            TRY_CONVERT(date, NULLIF(LTRIM(RTRIM(CONVERT(varchar(50), hire_date))), ''), 101),
            TRY_CONVERT(date, NULLIF(LTRIM(RTRIM(CONVERT(varchar(50), hire_date))), ''), 110)
        ) AS hire_date_clean,
        TRY_CONVERT(date, LEFT(NULLIF(LTRIM(RTRIM(CONVERT(varchar(50), termdate))), ''), 10), 23)
            AS termination_date
    FROM [HR Data]
),
Classified AS (
    SELECT *,
        CAST('2026-10-30' AS date) AS as_of_date,
        CASE
            WHEN termination_date IS NULL THEN 'Active'
            WHEN termination_date > CAST('2026-10-30' AS date) THEN 'Pending Termination'
            ELSE 'Terminated'
        END AS employee_status,
        CASE
            WHEN birth_date IS NULL THEN NULL
            ELSE DATEDIFF(year, birth_date, CAST('2026-10-30' AS date))
                 - CASE WHEN DATEADD(year,
                     DATEDIFF(year, birth_date, CAST('2026-10-30' AS date)),
                     birth_date) > CAST('2026-10-30' AS date)
                   THEN 1 ELSE 0 END
        END AS age
    FROM ParsedDates
)
SELECT id, gender, race, department, jobtitle, location,
       location_city, location_state, birth_date, hire_date_clean,
       termination_date, employee_status, age, as_of_date
FROM Classified;
GO

-- 3. Check conversion quality before trusting downstream calculations.
SELECT
    COUNT(*) AS total_records,
    SUM(CASE WHEN birth_date IS NULL THEN 1 ELSE 0 END) AS missing_or_invalid_birth_dates,
    SUM(CASE WHEN hire_date_clean IS NULL THEN 1 ELSE 0 END) AS missing_or_invalid_hire_dates,
    SUM(CASE WHEN termination_date IS NOT NULL THEN 1 ELSE 0 END) AS parsed_termination_dates
FROM dbo.vw_HR_Workforce_Cleaned;

-- 4. Check the employee-status split on the documented reference date.
SELECT employee_status, COUNT(*) AS employee_count
FROM dbo.vw_HR_Workforce_Cleaned
GROUP BY employee_status
ORDER BY employee_count DESC;

-- 5. Check the age range for implausible values.
SELECT MIN(age) AS youngest_age, MAX(age) AS oldest_age
FROM dbo.vw_HR_Workforce_Cleaned;
