-- Active: 1729712001528@@127.0.0.1@3306@Finlend_db

USE finlend_db;

-- Calculating maximum nps score by customer segment
SELECT customer_segment, 
        MAX(nps_score) as max_nps_score 
FROM customer_feedback 
GROUP BY customer_segment 
ORDER BY max_nps_score DESC
;

-- Calculating average nps score per month for 2023
WITH monthsCTE AS(
    SELECT YEAR(`date`) as years, 
            MONTHNAME(date) as months, 
            AVG(nps_score) as avg_nps_score, 
            MONTH(date) as month_num, 
            ROW_NUMBER() OVER(PARTITION BY YEAR(`date`) ORDER BY MONTH(date)) as row_num 
    FROM customer_feedback 
    WHERE YEAR(`date`) = 2023 
    GROUP BY YEAR(`date`),
             MONTHNAME(date),
             MONTH(date)
) 
SELECT months, avg_nps_score 
FROM `monthsCTE`
;

-- ACalculating average nps score per month for 2023
WITH monthsCTE AS(
    SELECT YEAR(`date`) as years, 
            MONTHNAME(date) as months, 
            AVG(nps_score) as avg_nps_score, 
            MONTH(date) as month_num, 
            ROW_NUMBER() OVER(PARTITION BY YEAR(`date`) ORDER BY MONTH(date)) as row_num 
    FROM customer_feedback 
    WHERE YEAR(`date`) = 2024 
    GROUP BY YEAR(`date`),
             MONTHNAME(date),
             MONTH(date)
) 
SELECT months, avg_nps_score 
FROM `monthsCTE`
;

-- NPS score distribution by product
(SELECT product, 
        MAX(nps_score) AS nps_score, 
        'Max' AS score_type 
FROM customer_feedback 
GROUP BY  product) 
UNION ALL 
(SELECT product, 
        MIN(nps_score) AS nps_score, 
        'Min' AS score_type 
FROM customer_feedback 
GROUP BY product)
;

-- NPS score distribution by customer segment
(SELECT customer_segment, 
        MAX(nps_score) AS nps_score, 
        'Max' AS score_type 
FROM customer_feedback 
GROUP BY  customer_segment) 
UNION ALL 
(SELECT customer_segment, 
        MIN(nps_score) AS nps_score, 
        'Min' AS score_type 
FROM customer_feedback 
GROUP BY customer_segment)
;

-- Customer feedback volume by customer segment
SELECT customer_segment, 
        MAX(feedback_volume) as max_feedback_volume 
FROM customer_feedback 
GROUP BY customer_segment 
ORDER BY max_feedback_volume DESC
;

-- Satisfaction score distribution by customer segment
(SELECT customer_segment, 
        MAX(satisfaction_score) as score, 
        'Maximum' as score_type 
FROM customer_feedback 
GROUP BY customer_segment) 
UNION ALL
(SELECT customer_segment, 
        MIN(satisfaction_score) as score, 
        'Minimum' as score_type 
FROM customer_feedback 
GROUP BY customer_segment)
;
