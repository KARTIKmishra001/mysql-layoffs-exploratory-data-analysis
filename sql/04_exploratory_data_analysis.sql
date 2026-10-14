/*
Project: Company Layoffs - Exploratory Data Analysis (EDA)
Database: MySQL
Source table: layoffs_staging2

Purpose:
Explore reported company layoffs by company, industry, country, company stage,
and time period after data cleaning.

Important interpretation notes:
1. SUM(total_laid_off) ignores NULL values. Therefore, totals in this analysis
   represent reported layoff counts and may not include every layoff.
2. Time-based queries exclude rows where date is NULL because those records
   cannot be assigned to a year or month.
3. A reported 100% percentage_laid_off value is interpreted as a full workforce
   layoff according to the dataset's recorded percentage; verify source context
   before making broader claims.
4. Rankings are based on the available reported total_laid_off values.
*/

-- ============================================================
-- 01. DATASET OVERVIEW
-- ============================================================

-- Inspect the cleaned dataset.
SELECT *
FROM layoffs_staging2;

-- Count records in the cleaned dataset.
SELECT COUNT(*) AS total_rows
FROM layoffs_staging2;

-- Check the earliest and latest available dates.
-- Rows with a NULL date are not represented in MIN/MAX results.
SELECT
    MIN(`date`) AS earliest_date,
    MAX(`date`) AS latest_date
FROM layoffs_staging2;

-- Find the largest recorded layoff count and percentage.
-- MAX() ignores NULL values.
SELECT
    MAX(total_laid_off) AS max_total_laid_off,
    MAX(percentage_laid_off) AS max_percentage_laid_off
FROM layoffs_staging2;


-- ============================================================
-- 02. COMPANY LAYOFF ANALYSIS
-- ============================================================

-- Companies with the highest cumulative reported layoffs.
-- SUM(total_laid_off) ignores NULL values.
SELECT
    company,
    SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY company
ORDER BY total_laid_off DESC;

-- Records where 100% of the workforce was reported laid off.
-- Ordered by the recorded layoff count, highest first.
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;


-- ============================================================
-- 03. INDUSTRY AND COUNTRY ANALYSIS
-- ============================================================

-- Total reported layoffs by industry.
SELECT
    industry,
    SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY industry
ORDER BY total_laid_off DESC;

-- Total reported layoffs by country.
SELECT
    country,
    SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY country
ORDER BY total_laid_off DESC;

-- Total reported layoffs by company stage.
SELECT
    stage,
    SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY stage
ORDER BY total_laid_off DESC;


-- ============================================================
-- 04. YEARLY AND MONTHLY TRENDS
-- ============================================================

-- Total reported layoffs by year.
-- Rows with a NULL date are excluded because YEAR(NULL) is NULL.
SELECT
    YEAR(`date`) AS layoff_year,
    SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
WHERE `date` IS NOT NULL
GROUP BY YEAR(`date`)
ORDER BY layoff_year;

-- Total reported layoffs by month.
-- DATE_FORMAT creates a YYYY-MM label from the DATE column.
-- Rows with a NULL date are explicitly excluded.
SELECT
    DATE_FORMAT(`date`, '%Y-%m') AS layoff_month,
    SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
WHERE `date` IS NOT NULL
GROUP BY DATE_FORMAT(`date`, '%Y-%m')
ORDER BY layoff_month;


-- ============================================================
-- 05. ROLLING TOTAL ANALYSIS
-- ============================================================

-- Calculate monthly totals first, then calculate a cumulative
-- rolling total in chronological order.
-- Rows with a NULL date are excluded from the monthly analysis.
WITH Monthly_Layoffs AS (
    SELECT
        DATE_FORMAT(`date`, '%Y-%m') AS layoff_month,
        SUM(total_laid_off) AS monthly_layoffs
    FROM layoffs_staging2
    WHERE `date` IS NOT NULL
    GROUP BY DATE_FORMAT(`date`, '%Y-%m')
)
SELECT
    layoff_month,
    monthly_layoffs,
    SUM(monthly_layoffs) OVER (
        ORDER BY layoff_month
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS rolling_total
FROM Monthly_Layoffs
ORDER BY layoff_month;


-- ============================================================
-- 06. TOP 5 COMPANIES PER YEAR
-- ============================================================

-- Calculate each company's total reported layoffs per year,
-- then rank companies within each year.
-- Rows with a NULL date are excluded because they cannot be
-- assigned to a year.
WITH Company_Year AS (
    SELECT
        company,
        YEAR(`date`) AS layoff_year,
        SUM(total_laid_off) AS total_laid_off
    FROM layoffs_staging2
    WHERE `date` IS NOT NULL
    GROUP BY company, YEAR(`date`)
),
Company_Year_Rank AS (
    SELECT
        company,
        layoff_year,
        total_laid_off,
        DENSE_RANK() OVER (
            PARTITION BY layoff_year
            ORDER BY total_laid_off DESC
        ) AS ranking
    FROM Company_Year
)
SELECT
    company,
    layoff_year,
    total_laid_off,
    ranking
FROM Company_Year_Rank
WHERE ranking <= 5
ORDER BY layoff_year DESC, ranking, company;


/*
END OF EDA SCRIPT

Interpretation reminder:
These queries summarize recorded layoff counts. Because NULL values in
total_laid_off are ignored by SUM(), results should be described as reported
layoffs rather than a guaranteed complete count of all layoffs.
*/
