-- -----------------------EXPLORATORY DATA ANALYSIS-------------------------------------
-- Calculate Summary Stats (Mean, Median, std dev, min, max) for key metrics
-- Aggregate Order Analysis
-- PERCENTILE_CONT(0.5) function isn't supported in current SQL. Workaround script below for computing median values. SQL version upgrade to be checked later.
-- Current MYSQL environment in VSCode showing an issue due to default auto row limit; working fine in native MYSQL
WITH median_value_orders AS (
    SELECT 
        'orders' AS field_name,
        ROUND(AVG(orders), 2) AS value_median
    FROM (
        SELECT
            orders,
            ROW_NUMBER() OVER (ORDER BY orders) AS rn,
            COUNT(*) OVER () AS cnt
        FROM demand_forecast
    ) AS OrderedValues
    WHERE rn IN ( (cnt + 1) DIV 2, (cnt + 2) DIV 2 )
),

median_value_units AS (
    SELECT 
        'units_sold' AS field_name,
        ROUND(AVG(units_sold), 2) AS value_median
    FROM (
        SELECT
            units_sold,
            ROW_NUMBER() OVER (ORDER BY units_sold) AS rn,
            COUNT(*) OVER () AS cnt
        FROM demand_forecast
    ) AS OrderedValues
    WHERE rn IN ( (cnt + 1) DIV 2, (cnt + 2) DIV 2 )
),

median_value_revenue AS (
    SELECT 
        'revenue' AS field_name,
        ROUND(AVG(revenue), 2) AS value_median
    FROM (
        SELECT
            revenue,
            ROW_NUMBER() OVER (ORDER BY revenue) AS rn,
            COUNT(*) OVER () AS cnt
        FROM demand_forecast
    ) AS OrderedValues
    WHERE rn IN ( (cnt + 1) DIV 2, (cnt + 2) DIV 2 )
),
median_value_tickets AS (
    SELECT 
        'customer_care_tickets' AS field_name,
        ROUND(AVG(customer_care_tickets), 2) AS value_median
    FROM (
        SELECT
            customer_care_tickets,
            ROW_NUMBER() OVER (ORDER BY customer_care_tickets) AS rn,
            COUNT(*) OVER () AS cnt
        FROM demand_forecast
    ) AS OrderedValues
    WHERE rn IN ( (cnt + 1) DIV 2, (cnt + 2) DIV 2 )
)

SELECT
    'orders' AS field_name,
    ROUND(AVG(orders),2) AS value_mean,
    (SELECT value_median FROM median_value_orders) AS value_median,
    ROUND(STDDEV(orders),2) AS value_stdev,
    ROUND(MIN(orders),2) AS value_min,
    ROUND(MAX(orders),2) AS value_max
FROM demand_forecast 

UNION ALL

SELECT
    'units_sold' AS field_name,
    ROUND(AVG(units_sold),2) AS value_mean,
    (SELECT value_median FROM median_value_units) AS value_median,
    ROUND(STDDEV(units_sold),2) AS value_stdev,
    ROUND(MIN(units_sold),2) AS value_min,
    ROUND(MAX(units_sold),2) AS value_max
FROM demand_forecast 

UNION ALL

SELECT
    'revenue' AS field_name,
    ROUND(AVG(revenue),2) AS value_mean,
    (SELECT value_median FROM median_value_revenue) AS value_median,
    ROUND(STDDEV(revenue),2) AS value_stdev,
    ROUND(MIN(revenue),2) AS value_min,
    ROUND(MAX(revenue),2) AS value_max
FROM demand_forecast 


UNION ALL

SELECT
    'customer_care_tickets' AS field_name,
    ROUND(AVG(customer_care_tickets),2) AS value_mean,
    (SELECT value_median FROM median_value_tickets) AS value_median,
    ROUND(STDDEV(customer_care_tickets),2) AS value_stdev,
    ROUND(MIN(customer_care_tickets),2) AS value_min,
    ROUND(MAX(customer_care_tickets),2) AS value_max
FROM demand_forecast
;

-- Analyze patterns by day of week, weekend/weekday, holiday/non-holiday, promo/non-promo
SELECT
    day_name,
    ROUND(AVG(orders),2) AS mean_orders,
    ROUND(AVG(units_sold),2) AS mean_unitsold,
    ROUND(AVG(revenue),2) AS mean_revenue,
    ROUND(AVG(customer_care_tickets),2) AS mean_tickets
FROM demand_forecast
GROUP BY 1



-- Calculate monthly and quarterly aggregations



-- Idenitfy seasonal trends

