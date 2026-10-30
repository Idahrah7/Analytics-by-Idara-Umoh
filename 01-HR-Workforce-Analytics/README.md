# HR Workforce Analytics | SQL

## Project overview

An exploratory HR analytics project using **Microsoft SQL Server** to clean employee records and examine workforce composition, departmental turnover, tenure, hiring, and termination trends.

**Original SQL script:** [View the analysis in my learning archive](https://github.com/Idahrah7/M4ace-Data-analysis/blob/main/HR_Analytics_Project_IdaraUmoh.sql..sql)

## Questions explored

- How is the workforce distributed across departments, job titles, locations, age groups, and gender?
- Which departments have the highest proportion of former employees?
- How long did former employees stay with the organization?
- How did hiring and terminations change over time?

## Methods demonstrated

- Cleaned termination-date strings with `TRY_CONVERT`.
- Calculated employee ages with birthday-aware date logic.
- Classified records as **Active**, **Pending Termination**, or **Terminated**.
- Checked for duplicate employee IDs and prepared a cleaned analysis table.
- Used grouped aggregations and **CTEs** to summarize departmental workforce measures.
- Used SQL window functions to rank departments and investigate trends.

## Selected findings from the project script

- The **Auditing** department had the highest reported former-employee proportion: **19.23%**.
- **Engineering** was the largest active workforce department.
- Former employees had an average reported tenure of approximately **8 years**.
- The analysis identified **185 distinct job titles**.

These are findings reported in the original SQL script and have not yet been independently reproduced against the source dataset.

## Interpretation and limitations

The script labels **former employees ÷ all employees in a department** as a “turnover rate.” Strictly speaking, this is a historical former-employee proportion, **not an annual employee turnover rate**, which ordinarily uses departures during a defined period and an appropriate average headcount denominator. The project will preserve this distinction in its polished reporting.

The analysis also uses `GETDATE()` for age and employee-status calculations, so results can change when rerun. The source dataset and its provenance need to be documented before publishing reproducible outputs.

## Next improvements

1. Refactor the SQL script into clear cleaning and analysis sections.
2. Validate results and calculation definitions.
3. Add a data dictionary and dataset source or a privacy-safe substitute.
4. Create a concise findings table and, where appropriate, dashboard visuals.

## Tools

Microsoft SQL Server · T-SQL · CTEs · Window Functions · Data Cleaning · Exploratory Analysis
