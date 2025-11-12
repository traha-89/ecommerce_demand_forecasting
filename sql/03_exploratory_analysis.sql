-- -----------------------EXPLORATORY DATA ANALYSIS-------------------------------------
-- Calculate Summary Stats (Mean, Median, std dev, min, max) for key metrics
-- Aggregate Order Analysis
SELECT
    'orders' AS field_name,
    ROUND(AVG(orders),2) AS value_mean,
    ROUND(STDDEV(orders),2) AS value_stdev,
    ROUND(MIN(orders),2) AS value_min,
    ROUND(MAX(orders),2) AS value_max
FROM demand_forecast

UNION ALL

SELECT
    'units_sold' AS field_name,
    ROUND(AVG(units_sold),2) AS value_mean,
    ROUND(STDDEV(units_sold),2) AS value_stdev,
    ROUND(MIN(units_sold),2) AS value_min,
    ROUND(MAX(units_sold),2) AS value_max
FROM demand_forecast

UNION ALL

SELECT
    'revenue' AS field_name,
    ROUND(AVG(revenue),2) AS value_mean,
    ROUND(STDDEV(revenue),2) AS value_stdev,
    ROUND(MIN(revenue),2) AS value_min,
    ROUND(MAX(revenue),2) AS value_max
FROM demand_forecast

UNION ALL

SELECT
    'customer_care_tickets' AS field_name,
    ROUND(AVG(customer_care_tickets),2) AS value_mean,
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
