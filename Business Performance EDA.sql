-- Active: 1729712001528@@127.0.0.1@3306@Finlend_db

USE finlend_db;

-- Calculating acquisition cost by marketing channel
SELECT channel, 
        SUM(acquisition_cost) as acquisition_cost 
FROM business_performance 
GROUP BY channel 
ORDER BY acquisition_cost DESC
; 

-- Calculating revenue by marketing channel
SELECT channel, 
        SUM(revenue) as total_revenue 
FROM business_performance 
GROUP BY channel 
ORDER BY total_revenue DESC
;

-- Maximum revenue generated by channel and product
SELECT product, 
        channel, 
        MAX(revenue) as revenue, 
        ROW_NUMBER () OVER(PARTITION BY product ORDER BY MAX(revenue) DESC) as row_num
FROM business_performance 
GROUP BY product,
         channel
;

-- Calculating revenue generated per month for 2023
WITH monthsCTE AS(
    SELECT YEAR(`date`) as years, 
            MONTHNAME(date) as months, 
            SUM(revenue) as total_revenue, 
            MONTH(date) as month_num, 
            ROW_NUMBER() OVER(PARTITION BY YEAR(`date`) ORDER BY MONTH(date)) as row_num 
    FROM business_performance 
    WHERE YEAR(`date`) = 2023 
    GROUP BY YEAR(`date`),
             MONTHNAME(date),
             MONTH(date)
) 
SELECT months, 
        total_revenue 
FROM `monthsCTE`
;

-- Calculating revenue generated per month for 2023
WITH monthsCTE AS(
    SELECT YEAR(`date`) as years, 
            MONTHNAME(date) as months, 
            SUM(revenue) as total_revenue, 
            MONTH(date) as month_num, 
            ROW_NUMBER() OVER(PARTITION BY YEAR(`date`) ORDER BY MONTH(date)) as row_num 
    FROM business_performance 
    WHERE YEAR(`date`) = 2024 
    GROUP BY YEAR(`date`),
             MONTHNAME(date),
             MONTH(date)
) 
SELECT months, 
        total_revenue 
FROM `monthsCTE`
;

-- Total profit and profit percentage by marketing channel
SELECT channel, 
        SUM(revenue - acquisition_cost) as total_profit, 
        ROUND(SUM(revenue - acquisition_cost) * 100.0 / (SELECT SUM(revenue - acquisition_cost) FROM business_performance),1) AS profit_percentage 
FROM business_performance 
GROUP BY channel 
ORDER BY total_profit DESC
;

-- Calculating profit and revenue generated by product
(SELECT product, 
        SUM(revenue) as value, 
        'Revenue' as title 
FROM business_performance 
GROUP BY product) 
UNION ALL
(SELECT product, 
        SUM(revenue - acquisition_cost) as value, 
        'Profit' as title 
FROM business_performance 
GROUP BY product)
;

-- Application volume distribution by channel
(SELECT channel, 
        MAX(application_volume) as app_volume, 
        'Max' as title 
FROM business_performance 
GROUP BY channel 
ORDER BY app_volume DESC)
UNION ALL
(SELECT channel, 
        MIN(application_volume) as app_volume, 
        'Min' as title 
FROM business_performance 
GROUP BY channel 
ORDER BY app_volume DESC)
;

-- Conversion rate and conversion percentage by marketing channel
SELECT channel, 
        SUM(conversion_rate) as conversion_rate, 
        ROUND(SUM(conversion_rate) * 100.0 / (SELECT SUM(conversion_rate) FROM business_performance),1) AS conversion_percentage 
FROM business_performance 
GROUP BY channel
;
