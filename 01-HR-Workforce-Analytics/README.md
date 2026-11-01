# HR Workforce Analytics | SQL Server

An SQL analysis of **22,214 employee records** to explore workforce distribution, employee departures, and hiring trends, with recommendations to support HR decision-making.

**Tools:** Microsoft SQL Server (T-SQL)

## Project Overview

This project examines workforce composition, employee tenure, and hiring and termination patterns using Microsoft SQL Server. The aim is to identify useful workforce insights and areas that HR management could investigate further.

## Key Metrics

| Metric | Result |
|---|---:|
| Total Employee Records | 22,214 |
| Current Workforce | 19,301 |
| Former Employees | 2,913 |
| Departments | 13 |
| Average Former-Employee Tenure | 8.50 years |

## Key Findings

- **Workforce distribution:** Engineering is the largest department, with 5,800 current employees (30.05%), followed by Accounting with 2,903 (15.04%).
- **Employee departures:** Auditing has the highest historical former-employee proportion (19.23%), followed by Legal (16.72%). Auditing's result is based on just 52 employee records.
- **Employee tenure:** Former employees stayed an average of 8.50 years, with recorded tenure ranging from 0.09 to 21.08 years.
- **Hiring trends:** Hiring peaked in 2018 with 1,147 employees, before declining by approximately 6.6% between 2019 and 2020.
- **Termination trends:** Recorded terminations peaked at 205 in 2021.

## Recommendations for HR Management

1. **Workforce planning:** Review staffing needs and resource allocation in Engineering, which represents approximately 30% of the current workforce.
2. **Retention analysis:** Investigate employee departure patterns in Auditing and Legal using tenure comparisons and exit interview data.
3. **Data-driven reporting:** Introduce annual turnover measures and automated data-validation checks to improve workforce reporting.

## SQL Analysis & Project Files

| File | Description |
|---|---|
| [Data Cleaning](01_data_cleaning.sql) | Prepared and validated employee records |
| [Workforce Analysis](02_workforce_analysis.sql) | Analyzed departments, demographics, and employee distribution |
| [Employee Departures](03_employee_departures.sql) | Examined departures and employee tenure |
| [Hiring Trends](04_hiring_trends.sql) | Analyzed annual hiring and termination trends |

**SQL techniques:** `GROUP BY`, `CASE`, CTEs, `RANK()`, `DATEDIFF()`, `UNION ALL`, and window functions.

## Data Quality & Limitations

Employee-status classifications were validated across all 22,214 records, with no classification errors identified.

The analysis also found **66 records with hiring dates earlier than birth dates**. These inconsistencies were present in the original data and were preserved.

Departmental former-employee percentages are historical proportions, not annual turnover rates. Hiring records end in 2020, and some termination dates are in the future. Results involving employee status depend on the analysis date.

The original dataset is not included in this repository, and its source has not yet been documented.
