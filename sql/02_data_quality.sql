###-----------------DATA QUALITY CHECKS----------------------###
# Check for missing values
SELECT * 
FROM demand_forecast
WHERE 
    orders IS NULL OR
    units_sold IS NULL OR
    revenue IS NULL OR
    customer_care_tickets IS NULL OR
    is_weekend IS NULL OR
    is_holiday IS NULL OR
    is_promotion IS NULL;
-- No missing values observed in any of the columns

# Identify any date gaps
WITH date_log AS (
    SELECT 
        date,
        LAG(DATE) OVER (ORDER BY date) as prev_date
    FROM demand_forecast
)
SELECT
    date,
    prev_date,
    DATE_ADD(prev_date, INTERVAL 1 DAY) AS missing_date
FROM date_log
WHERE DATEDIFF(date,prev_date) > 1;
-- We are missing data for '29-10-2023' and '27-10-2024' dates.

# Detect outliers in orders, units_sold and tickets
