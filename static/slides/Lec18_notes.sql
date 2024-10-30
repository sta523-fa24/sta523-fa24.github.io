## Exercise 1

### 1. The total costs in payroll for this company

SELECT SUM(salary) FROM employees;

### 2. The average salary within each department

SELECT dept, AVG(salary) FROM employees GROUP BY dept;


## Exercise 2

SELECT *, round(salary-avg,2) AS diff 
FROM employees
NATURAL JOIN  (
  SELECT dept, round(avg(salary),2) AS avg FROM employees GROUP BY dept
) dept_avg
ORDER dept, diff;

## ┌─────────┬───────────────────┬─────────┬────────────┬──────────┬─────────┐
## │  name   │       email       │ salary  │    dept    │   avg    │  diff   │
## │ varchar │      varchar      │ double  │  varchar   │  double  │ double  │
## ├─────────┼───────────────────┼─────────┼────────────┼──────────┼─────────┤
## │ Alice   │ alice@company.com │ 52000.0 │ Accounting │ 41666.67 │ 10333.0 │
## │ Bob     │ bob@company.com   │ 40000.0 │ Accounting │ 41666.67 │ -1667.0 │
## │ Carol   │ carol@company.com │ 30000.0 │ Sales      │  37000.0 │ -7000.0 │
## │ Dave    │ dave@company.com  │ 33000.0 │ Accounting │ 41666.67 │ -8667.0 │
## │ Eve     │ eve@company.com   │ 44000.0 │ Sales      │  37000.0 │  7000.0 │
## │ Frank   │ frank@comany.com  │ 37000.0 │ Sales      │  37000.0 │     0.0 │
## └─────────┴───────────────────┴─────────┴────────────┴──────────┴─────────┘


## Demo

# https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page

# https://d37ci6vzurychx.cloudfront.net/misc/taxi_zone_lookup.csv


### Basics
.timer on

SELECT count(*) FROM read_parquet("/data/nyctaxi/yellow_*.parquet")

DESCRIBE SELECT * FROM read_parquet("/data/nyctaxi/yellow_*.parquet");


### Tip percentage

SELECT avg(tip_amount / total_amount) AS mean_tip_frac FROM read_parquet("/data/nyctaxi/yellow_*.parquet") GROUP BY payment_type;

SELECT round(avg(tip_amount / total_amount),4) AS mean_tip_frac, payment_type 
  FROM read_parquet("/data/nyctaxi/yellow_*.parquet") 
  WHERE tip_amount >= 0 AND fare_amount > 0 
  GROUP BY payment_type 
  ORDER BY payment_type;


### Cost per mile

SELECT 
    PULocationID pickup_zone,
    AVG(fare_amount / trip_distance) fare_per_mile,
    COUNT(*) num_rides 
FROM read_parquet("/data/nyctaxi/yellow_*.parquet") 
WHERE trip_distance > 0
GROUP BY PULocationID
ORDER BY PULocationID;


SELECT * FROM (
  SELECT 
    PULocationID pickup_zone,
    AVG(fare_amount / trip_distance) fare_per_mile,
    COUNT(*) num_rides 
  FROM read_parquet("/data/nyctaxi/yellow_*.parquet") 
  WHERE trip_distance > 0
  GROUP BY PULocationID
  ORDER BY PULocationID
) NATURAL LEFT JOIN (
 SELECT LocationID AS pickup_zone, * FROM read_csv("https://d37ci6vzurychx.cloudfront.net/misc/taxi_zone_lookup.csv")
) ORDER BY pickup_zone;
