# HR Workforce Analytics | SQL Server & Power BI

An end-to-end analysis of **22,214 employee records** examining workforce composition, departmental staffing, employee departures, tenure, and historical hiring trends.

**Tools:** Microsoft SQL Server (T-SQL), Power BI, DAX

## Project Overview

This project uses SQL to clean and analyze HR records and Power BI to present the findings in an interactive, two-page dashboard. The goal is to understand the workforce, compare departmental patterns, and identify questions that HR management could investigate further.

## Power BI Dashboard

Explore the completed two-page Power BI report, combining workforce trends with employee demographics, work locations, and tenure.

### Page 1 — HR Workforce Overview

Workforce KPIs, employee status, department distribution, historical departure proportions, annual hiring, and departures.

<img width="1097" height="773" alt="image" src="https://github.com/user-attachments/assets/25dc365f-7ca5-44de-abc4-e5d32aee2838" />


### Page 2 — Employee Insights

Employee demographics, remote and headquarters staffing by department, former-employee tenure distribution, and historical departure proportions by gender.

![Employee Insights](screenshots/employee-insights.png)

**Interactivity:** Department and Gender slicers are synchronized across both report pages.

**[Download the Power BI report (.pbix)](HR_Workforce_Analytics.pbix)**

## Key Metrics

| Metric | Result |
|---|---:|
| Total Employee Records | 22,214 |
| Current Workforce (Active + Pending Termination) | 19,301 |
| Former Employees | 2,913 |
| Departments | 13 |
| Average Former-Employee Tenure | 8.50 years |
| Remote Current Employees | 4,821 |
| Headquarters Current Employees | 14,480 |
| Remote Share of Current Workforce | 25.0% |

## Key Findings

- **Workforce distribution:** Engineering is the largest department, with **5,800 current employees (30.05%)**, followed by Accounting with **2,903 (15.04%)**.
- **Historical departures:** Auditing has the highest historical former-employee proportion (**19.23%**), followed by Legal (**16.72%**). Auditing's percentage is based on only **52 employee records**, so its small sample size matters.
- **Employee tenure:** Former employees stayed an average of **8.50 years**, with recorded tenure ranging from **0.09 to 21.08 years**. The **6–10 years** group is the largest former-employee tenure category.
- **Work locations:** **4,821 of 19,301 current employees (25.0%)** work remotely; **14,480** work at headquarters. Comparing remote shares by department provides more context than comparing counts alone.
- **Hiring trends:** Recorded hiring peaked in **2018 (1,147 hires)**. Hiring records end in 2020.
- **Departure trends:** Recorded terminations peaked in **2021 (205 departures)**.

## Recommendations for HR Management

1. **Workforce planning:** Review staffing requirements and resource allocation in Engineering, which represents approximately 30% of the current workforce.
2. **Retention investigation:** Examine departure patterns in Auditing and Legal, using additional years of data, exit interviews, and department-size context before drawing conclusions.
3. **Remote-work planning:** Compare the share of remote employees across departments to identify different staffing arrangements and possible support needs.
4. **Reporting quality:** Establish routine checks for impossible dates, track departures over consistent time periods, and calculate annual turnover using an appropriate workforce denominator.

## SQL Analysis & Project Files

| File | Description |
|---|---|
| [01_data_cleaning.sql](01_data_cleaning.sql) | Cleaning, employee-status classification, and data-quality checks |
| [02_workforce_analysis.sql](02_workforce_analysis.sql) | Demographics, department and job-title distributions, HQ/remote comparisons |
| [03_employee_departures.sql](03_employee_departures.sql) | Historical departure proportions, tenure, retention comparisons, and age at departure |
| [04_hiring_trends.sql](04_hiring_trends.sql) | Annual hiring and terminations, workforce-change queries, and hiring-age analysis |

**SQL techniques:** `GROUP BY`, `CASE`, CTEs, `RANK()`, `DATEDIFF()`, `UNION ALL`, and window functions.

**Power BI techniques:** DAX measures and calculated columns, KPI cards, bar and column charts, donut charts, line charts, and synchronized slicers.

## Data Quality & Limitations

- Employee-status classifications were validated across all **22,214** records, with no classification errors identified in the SQL checks.
- **66 records have hiring dates earlier than birth dates.** These source-data inconsistencies were preserved and should be excluded or corrected for analyses affected by them.
- Departmental and gender-based former-employee percentages represent **historical proportions of recorded employees**, not annual turnover rates.
- Hiring records end in **2020**, while termination records extend later. Therefore, post-2020 net workforce change and cumulative growth cannot be treated as complete measures of actual workforce growth.
- Some termination dates are in the future and are classified as **Pending Termination**; employee status depends on the analysis date.
- The original dataset is not included in this repository, and its source has not yet been documented.
