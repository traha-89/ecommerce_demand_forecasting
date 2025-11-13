-- -----------------------EXPLORATORY DATA ANALYSIS-------------------------------------
-- Calculate Summary Stats (Mean, Median, std dev, min, max) for key metrics
-- -------------------------------------------------------------------------------------
-- PERCENTILE_CONT(0.5) function isn't supported in my current MySQL v8.0.43. Workaround script below for computing median values.
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

# The order counts vary from 119 to 4346 orders per day. The mean order value of 926.85 is higher than 823 median orders, which shows a positively skewed distribution.
# Similar pattern can be seen for units sold, revenue and customer tickets.

-- -------------------------------------------------------------------------------------
-- Analyze patterns by day of week, weekend/weekday, holiday/non-holiday, promo/non-promo
-- -------------------------------------------------------------------------------------
SELECT
    day_name,
    ROUND(AVG(orders),2) AS mean_orders,
    ROUND(AVG(units_sold),2) AS mean_unitsold,
    ROUND(AVG(revenue),2) AS mean_revenue,
    ROUND(AVG(customer_care_tickets),2) AS mean_tickets
FROM demand_forecast
GROUP BY 1;

# We have higher mean orders and units sold on Monday, Tuesday and Thursdays. Weekends show a lower trend. Highest mean orders are on Tuesday (1072).
# We observe a similar trend for customer tickets, with the highest mean tickets being raised on Tuesday (115).
SELECT
    is_weekend,
    ROUND(AVG(orders),2) AS mean_orders,
    ROUND(AVG(units_sold),2) AS mean_unitsold,
    ROUND(AVG(revenue),2) AS mean_revenue,
    ROUND(AVG(customer_care_tickets),2) AS mean_tickets
FROM demand_forecast
GROUP BY 1;

# Over weekends, the mean daily orders is 672, vs. 1029 on weekends. Generally we see higher activity during the weekdays.
# Similarly, we have higher mean daily tickets raised during the weekdays (109).

SELECT
    is_holiday,
    ROUND(AVG(orders),2) AS mean_orders,
    ROUND(AVG(units_sold),2) AS mean_unitsold,
    ROUND(AVG(revenue),2) AS mean_revenue,
    ROUND(AVG(customer_care_tickets),2) AS mean_tickets
FROM demand_forecast
GROUP BY 1;

# Over holidays, the mean daily orders is 1145, vs. 921 for non-holidays. Generally we see higher activity during the holidays.
# Similarly, we have higher mean daily tickets during holidays, when the ordering is more.

SELECT
    is_promotion,
    ROUND(AVG(orders),2) AS mean_orders,
    ROUND(AVG(units_sold),2) AS mean_unitsold,
    ROUND(AVG(revenue),2) AS mean_revenue,
    ROUND(AVG(customer_care_tickets),2) AS mean_tickets
FROM demand_forecast
GROUP BY 1;

# As expected, there is a significant spike in mean daily orders during promo (1564) vs. for non-promo 873 mean orders.
# Similarly, there is a significant increase in mean daily tickets during promo days (216 for promo days).

-- -------------------------------------------------------------------------------------
-- Calculate monthly and quarterly aggregations
-- -------------------------------------------------------------------------------------

SELECT
    month_name,
    ROUND(AVG(orders),2) AS mean_orders,
    ROUND(AVG(units_sold),2) AS mean_unitsold,
    ROUND(AVG(revenue),2) AS mean_revenue,
    ROUND(AVG(customer_care_tickets),2) AS mean_tickets
FROM demand_forecast
GROUP BY 1;

# Peak Ordering happens from May till August. Highest mean daily orders are in August (1439).
# We observe similar pattern for tickets, however, the highest mean daily tickets are seen in July (171).

SELECT
    quarter,
    ROUND(AVG(orders),2) AS mean_orders,
    ROUND(AVG(units_sold),2) AS mean_unitsold,
    ROUND(AVG(revenue),2) AS mean_revenue,
    ROUND(AVG(customer_care_tickets),2) AS mean_tickets
FROM demand_forecast
GROUP BY 1;

# Peak Ordering happens in the 2nd and 3rd quarter. Highest mean daily orders are in 3rd quarter (1142).
# Similarly, highest mean daily tickets are seen in the 3rd quarter (123). 

SELECT
    year,
    ROUND(AVG(orders),2) AS mean_orders,
    ROUND(AVG(units_sold),2) AS mean_unitsold,
    ROUND(AVG(revenue),2) AS mean_revenue,
    ROUND(AVG(customer_care_tickets),2) AS mean_tickets
FROM demand_forecast
GROUP BY 1;

# Mean daily orders increased from 2023 (875) to 2024 (978), which reflects growing activity from customers. 
# Accordingly, mean daily tickets also increased from 93 to 103 in 2024.

-- -------------------------------------------------------------------------------------
-- Identify seasonal trends
-- -------------------------------------------------------------------------------------
