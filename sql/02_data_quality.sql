-- ----------------- DATA QUALITY CHECKS ----------------------

-- Check for missing values
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

-- Identify any date gaps
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
-- Missing data detected for '29-10-2023' and '27-10-2024' dates.

-- Detect outliers in orders, units_sold and tickets
-- Calculation of average and standard deviation values to detect outliers
-- Upper Threshold for Outlier = Mean Value + 3 * Std. Devn. || Lower Threshold for Outlier = Mean Value - 3 * Std. Devn.
WITH summary_stats AS (
    SELECT 
        ROUND(AVG(orders),2) AS avg_orders,
        ROUND(AVG(units_sold),2) AS avg_units,
        ROUND(AVG(customer_care_tickets),2) AS avg_tickets,
        STDDEV(orders) AS std_orders,
        STDDEV(units_sold) AS std_units,
        STDDEV(customer_care_tickets) AS std_tickets
    FROM demand_forecast
)
-- Creating a combined table of all outlier values considering orders, units_sold and customer_care_tickets
SELECT
    date, 
    avg_orders,
    orders,
    avg_units,
    units_sold,
    avg_tickets,
    customer_care_tickets,
    is_weekend,
    is_holiday,
    is_promotion
FROM demand_forecast
LEFT JOIN summary_stats ON 1=1
-- Outlier Conditions
WHERE 
    orders > (avg_orders + 3*std_orders) OR orders < (avg_orders - 3*std_orders)
    OR units_sold > avg_units + 3 * std_units OR units_sold < avg_units - 3 * std_units
    OR customer_care_tickets > avg_tickets + 3 * std_tickets OR customer_care_tickets < avg_tickets - 3 * std_tickets;

-- Based on the data retrieved, the outliers are all positive ones with majority values in July.
-- These uplifts in July seem to be driven by promotions, as validated by is_promotion column.

