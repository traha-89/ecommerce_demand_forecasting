###--------------CREATE TABLE TO REPLICATE daily_demand TABLE-----------------------------------------------###
###--------------CREATE SCHEMA FOR DATA TABLE---------------------------------------------------------------###
CREATE TABLE ops_fcst.demand_forecast (
  date DATE,
  orders INT,
  units_sold INT,
  revenue DECIMAL(10,2),
  customer_care_tickets INT,
  is_weekend TINYINT(1),
  is_holiday TINYINT(1),
  is_promotion TINYINT(1)
);

###--------------LOAD DATA FROM CSV TABLE--------------------------------------------------------------------###
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/daily_demand.csv'
INTO TABLE demand_forecast
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(date, orders, units_sold, revenue, customer_care_tickets, is_weekend, is_holiday, is_promotion);

