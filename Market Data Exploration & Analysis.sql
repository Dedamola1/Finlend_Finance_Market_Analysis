-- Active: 1729712001528@@127.0.0.1@3306@Finlend_db
USE finlend_db;

-- Updating column name and dropppind unwanted columns
ALTER TABLE customer_feedback
CHANGE MyUnknownColumn date datetime;

ALTER TABLE market_data
DROP COLUMN digital_maturity;

-- Calculating total competitor revenue 
SELECT competitor,
        SUM(competitor_revenue) AS total_revenue
FROM market_data
GROUP BY competitor
ORDER BY total_revenue DESC
;

-- Calculating total revenue by product and competitor 
WITH productCTE AS(
        SELECT product,
                competitor,
                SUM(competitor_revenue) as total_revenue,
                ROW_NUMBER () OVER(PARTITION BY product ORDER BY SUM(competitor_revenue) DESC) as row_num
        FROM market_data
        GROUP BY product, competitor
)
SELECT product,
        competitor,
        total_revenue
FROM `productCTE`
;

-- Calculating maximum revenue by product and competitor
WITH competitorCTE AS(
        SELECT product,
                competitor,
                MAX(competitor_revenue) as max_revenue,
                ROW_NUMBER () OVER(PARTITION BY product ORDER BY MAX(competitor_revenue) DESC) as row_num
        FROM market_data
        GROUP BY product, competitor
)
SELECT product,
        competitor,
        max_revenue
FROM `competitorCTE`
;

-- Calculating total competitor revenue by product for 2023
WITH monthsCTE AS(
        SELECT MONTHNAME(date) as months, 
                product, 
                SUM(competitor_revenue) as total_revenue, 
                MONTH(date) as month_num, 
                ROW_NUMBER() OVER(PARTITION BY product ORDER BY MONTH(date)) as row_num
        FROM market_data 
        WHERE YEAR(`date`) = 2023 
        GROUP BY MONTHNAME(date),
                 product,
                 MONTH(date)
)
SELECT months, 
        product, 
        total_revenue 
FROM `monthsCTE`
;

-- Calculating total competitor revenue by product for 2024
WITH monthsCTE AS(
        SELECT MONTHNAME(date) as months, 
                product, 
                SUM(competitor_revenue) as total_revenue, 
                MONTH(date) as month_num, 
                ROW_NUMBER() OVER(PARTITION BY product ORDER BY MONTH(date)) as row_num
        FROM market_data 
        WHERE YEAR(`date`) = 2024 
        GROUP BY MONTHNAME(date),
                 product,
                 MONTH(date)
)
SELECT months, 
        product, 
        total_revenue 
FROM `monthsCTE`
;

-- Calculating competitor market share percentage distribution
SELECT competitor, 
        SUM(competitor_revenue) AS total_revenue, 
        ROUND(SUM(competitor_revenue) * 100.0 / (SELECT SUM(competitor_revenue) FROM market_data),1) AS revenue_percentage
FROM market_data 
GROUP BY competitor;

-- Calculating total product revenue by competitor
SELECT product, 
        SUM(competitor_revenue) as revenue 
FROM market_data 
GROUP BY product 
ORDER BY revenue DESC; 

-- Calculating revenue distribution by competitor and year
SELECT YEAR(date) as years, 
        competitor, 
        SUM(competitor_revenue) as total_revenue, 
        ROW_NUMBER() OVER(PARTITION BY YEAR(date) ORDER BY SUM(competitor_revenue) DESC) as row_num 
FROM market_data 
GROUP BY YEAR(date), competitor;

-- Average satisfaction value by competitor
SELECT competitor, 
        ROUND(AVG(customer_satisfaction),2) as avg_satisfaction_value 
FROM market_data GROUP BY competitor;