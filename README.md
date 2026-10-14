# MySQL Exploratory Data Analysis — Company Layoffs

An SQL-based Exploratory Data Analysis (EDA) project exploring reported company layoffs across companies, industries, countries, company stages, and time periods.

This project is part of my learning journey toward becoming a Data Analyst. It builds on the data-cleaning stage by using SQL to explore patterns in a prepared dataset.

## Project Overview

The goal is to use MySQL to answer questions such as:

- Which companies have the highest cumulative reported layoffs?
- How do reported layoffs vary across industries, countries, and company stages?
- How do reported layoffs change by year and month?
- What does the cumulative monthly total look like over time?
- Which companies rank among the top five for reported layoffs in each year?

## Repository Structure

```text
mysql-layoffs-exploratory-data-analysis/
├── README.md
├── data/
│   └── layoffs_raw.csv
├── sql/
│   └── 04_exploratory_data_analysis.sql
└── results/
    └── result_pdf
```

## Tools and SQL Skills

- MySQL
- `SELECT`, `WHERE`, `GROUP BY`, and `ORDER BY`
- Aggregate functions such as `SUM()`, `MIN()`, and `MAX()`
- Date functions such as `YEAR()` and `DATE_FORMAT()`
- Common Table Expressions (CTEs)
- Window functions such as `SUM() OVER()` and `DENSE_RANK()`
- Ranking and rolling cumulative totals

## Dataset

The `data/layoffs_raw.csv` file contains the supplied raw company layoffs dataset. The original data covers 2020–2023 and contains 2,361 rows and 9 columns.

**Important:** The CSV in this repository is the raw dataset, not the cleaned output. The EDA script is written to query the cleaned MySQL table `layoffs_staging2`, which was created during the data-cleaning stage. Run the cleaning workflow first, or import your verified cleaned CSV into MySQL under the table name `layoffs_staging2` before running the EDA script.

Related data-cleaning project: https://github.com/KARTIKmishra001/mysql-layoffs-data-cleaning

## How to Run

1. Install MySQL and open MySQL Workbench.
2. Import the raw CSV into your database and complete the cleaning workflow from the related data-cleaning project.
3. Ensure the cleaned table exists as `world_layoffs.layoffs_staging2`, or select the correct database and update the script's table references to match your setup.
4. Open `sql/04_exploratory_data_analysis.sql`.
5. Run the queries section by section.
6. Review the result grids and save relevant outputs or screenshots in the `results/` folder.
7. Record findings in a separate results summary only after checking the actual query results.

## Analysis Sections

1. **Dataset Overview** — row count, date range, maximum reported layoff count, and maximum recorded layoff percentage.
2. **Company Layoff Analysis** — companies with the highest cumulative reported layoffs and records with a 100% reported layoff percentage.
3. **Industry and Country Analysis** — reported layoffs by industry, country, and company stage.
4. **Yearly and Monthly Trends** — reported layoffs aggregated by year and month.
5. **Rolling Total Analysis** — cumulative monthly reported layoffs using a window function.
6. **Top 5 Companies Per Year** — yearly company rankings using `DENSE_RANK()`.

## Data Limitations

- `SUM(total_laid_off)` ignores `NULL` values. Totals therefore represent **reported layoff counts** and may not include every layoff.
- Records with missing dates are excluded from yearly and monthly trend queries because they cannot be assigned to a time period.
- Rankings depend on the available values in `total_laid_off`.
- `DENSE_RANK()` can return more than five companies for a year when there is a tie at the fifth rank.
- The dataset covers 2020–2023. Dates have not been altered to represent a different period.
- Findings should be described as patterns in this dataset, not proof that one factor caused layoffs.

## Results

The SQL file contains the analysis queries. Query outputs and conclusions should be added to `results/` after the script is run against the cleaned table. No findings are claimed in advance of verifying the results.

## Learning Outcomes

Through this project, I practiced using SQL to aggregate records, compare categories, analyze time-based trends, calculate rolling totals, and rank companies. This work helped me understand how exploratory analysis follows data cleaning in a typical data-analysis workflow.

## Author

**Kartik Mishra**  
Aspiring Data Analyst

GitHub: https://github.com/KARTIKmishra001
