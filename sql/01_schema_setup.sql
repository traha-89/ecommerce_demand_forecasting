-- --------------CREATE TABLE TO REPLICATE daily_demand TABLE-----------------------------------------------
-- --------------CREATE SCHEMA FOR DATA TABLE---------------------------------------------------------------
DROP TABLE IF EXISTS ops_fcst.demand_forecast;
CREATE TABLE ops_fcst.demand_forecast (
  date DATE,
  orders INT,
  units_sold INT,
  revenue DECIMAL(10,2),
  customer_care_tickets INT,
  is_weekend TINYINT(1),
  is_holiday TINYINT(1),
  is_promotion TINYINT(1),
  day_name VARCHAR(15),
  day_of_month INT,
  week_of_year INT,
  month INT,
  month_name VARCHAR(15),
  quarter INT,
  year INT
  
);

-- --------------LOAD DATA FROM CSV TABLE--------------------------------------------------------------------
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/daily_demand.csv' 
INTO TABLE demand_forecast
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(date, orders, units_sold, revenue, customer_care_tickets, is_weekend, is_holiday, is_promotion)
SET day_name = DAYNAME(date),
    day_of_month = DAY(date),
    week_of_year = WEEKOFYEAR(date),
    month = MONTH(date),
    month_name = MONTHNAME(date),
    quarter = QUARTER(date),
    year = YEAR(date);
    

