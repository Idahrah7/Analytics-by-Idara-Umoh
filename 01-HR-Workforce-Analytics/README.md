# HR Workforce Analytics | SQL Server & Power BI

An end-to-end HR analytics project exploring **22,214 employee records** to uncover insights into workforce composition, employee departures, demographics, and hiring trends.

**Tools:** SQL Server • Power BI • DAX • Data Cleaning • Data Visualization

---

## 📊 Dashboard Preview

### Page 1 — HR Workforce Overview

An overview of workforce size, employee status, departmental distribution, historical departures, and hiring trends.

<img width="1097" alt="HR Workforce Overview Dashboard" src="https://github.com/user-attachments/assets/25dc365f-7ca5-44de-abc4-e5d32aee2838" />

### Page 2 — Employee Insights

An analysis of employee demographics, work locations, departmental staffing, and tenure patterns.

<img width="1157" alt="Employee Insights Dashboard" src="https://github.com/user-attachments/assets/68010414-e031-46f4-91cd-0defa676dc17" />

Both dashboard pages include synchronized Department and Gender slicers for interactive exploration.

---

## 📌 Project Overview

Understanding workforce trends is essential for effective human resource planning and decision-making.

This project combines SQL-based data cleaning and exploratory analysis with interactive Power BI dashboards to answer important workforce questions:

- How is the workforce distributed across departments?
- Which departments have the highest historical departure proportions?
- What do employee demographics reveal about workforce composition?
- How do remote and headquarters staffing patterns differ?
- What trends can be identified in historical hiring and employee departures?

## 📈 Key Performance Indicators

| Metric | Value |
|---|---:|
| Total Employee Records | 22,214 |
| Current Employees | 19,301 |
| Former Employees | 2,913 |
| Departments | 13 |
| Average Former-Employee Tenure | 8.50 years |
| Remote Employees | 4,821 |
| Headquarters Employees | 14,480 |

*Current employees include active employees and those pending termination.*

## 🔍 Key Insights

**1. Workforce Distribution**

Engineering accounts for the largest share of current employees, with **5,800 employees (30.05%)**, followed by Accounting with **2,903 employees (15.04%)**.

**2. Employee Departures**

Auditing recorded the highest historical departure proportion at **19.23%**, followed by Legal at **16.72%**. Auditing's relatively small employee population means its results should be interpreted carefully.

**3. Employee Tenure**

Former employees had an average tenure of **8.50 years**, with the largest group falling within the **6–10-year** tenure range.

**4. Work Location**

Approximately **25% of the current workforce works remotely**, while 75% works at headquarters. Department-level comparisons provide further insight into these arrangements.

**5. Historical Workforce Trends**

Recorded hiring peaked in **2018 with 1,147 hires**, while recorded departures peaked in **2021 with 205 terminations**.

## 🛠️ Data Analysis Process

### 1. Data Cleaning and Preparation — SQL Server

- Examined data quality and inconsistencies.
- Validated employee records and date fields.
- Classified employees as Active, Terminated, or Pending Termination.
- Prepared cleaned data for workforce analysis.

### 2. Exploratory Data Analysis — SQL

Analyzed employee demographics, departmental distribution, job roles, tenure, work locations, hiring trends, and historical departures.

**SQL techniques used:** Joins, Common Table Expressions (CTEs), conditional logic, aggregations, date functions, and window functions.

### 3. Data Visualization — Power BI

Developed a two-page interactive dashboard using:

- DAX measures and calculated columns
- KPI cards
- Bar and column charts
- Donut charts
- Line charts
- Synchronized slicers

## 💡 Business Recommendations

- **Workforce planning:** Review staffing requirements in Engineering, the organization's largest department.
- **Retention analysis:** Investigate historical departure patterns in Auditing and Legal before designing targeted retention initiatives.
- **Remote workforce management:** Evaluate differences in remote staffing across departments to inform workforce policies.
- **Data quality:** Strengthen employee-record validation and establish consistent workforce reporting practices.

## 📁 Project Files

| File | Description |
|---|---|
| [01_data_cleaning.sql](01_data_cleaning.sql) | Data preparation, cleaning, and validation |
| [02_workforce_analysis.sql](02_workforce_analysis.sql) | Workforce composition and demographic analysis |
| [03_employee_departures.sql](03_employee_departures.sql) | Employee departures and tenure analysis |
| [04_hiring_trends.sql](04_hiring_trends.sql) | Historical hiring and termination trends |

## ⚠️ Data Limitations

- The dataset contains 66 records with inconsistent birth and hiring dates.
- Historical departure proportions should not be interpreted as annual employee turnover rates.
- Hiring records end in 2020, limiting comparisons with later termination records.
- Employee status is dependent on the analysis date.
- The original dataset source has not yet been documented.

---

**Project focus:** Transforming workforce data into actionable insights through SQL analysis, business intelligence, and data visualization.
