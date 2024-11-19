-- Active: 1729712001528@@127.0.0.1@3306@Finlend_db

USE finlend_db;

-- Calculating product interest distribution by age group 
WITH ageCTE AS (
    SELECT age_group, 
            product_interest, 
            COUNT(product_interest) as total_count, 
            ROW_NUMBER() OVER(PARTITION BY age_group ORDER BY COUNT(product_interest) DESC) as row_num
    FROM market_research 
    GROUP BY age_group, 
            product_interest
)
SELECT age_group,
        product_interest,
        total_count 
FROM `ageCTE`
;

-- Calculating inncome level distribution by income percentage and age group
WITH income_totals AS (
    SELECT age_group,
            income_level,
            COUNT(income_level) AS total_count 
    FROM market_research 
    GROUP BY age_group, income_level
)
SELECT age_group,
        income_level,
        total_count * 100.0 / SUM(total_count) OVER(PARTITION BY age_group) AS income_percentage,ROW_NUMBER() OVER(PARTITION BY age_group ORDER BY total_count DESC) AS row_num
FROM income_totals 
ORDER BY age_group, row_num
;

-- Digital preference percentage by market segment
SELECT segment, 
        SUM(digital_preference) as digital_preference, 
        ROUND(SUM(digital_preference) *100.0/(SELECT SUM(digital_preference) FROM market_research),1) AS digital_preference_percentage 
FROM market_research 
GROUP BY segment 
ORDER BY SUM(digital_preference) DESC
;

-- Brand preference percentage by market segment
SELECT segment, 
        SUM(brand_importance) as brand_importance, 
        ROUND(SUM(brand_importance) *100.0/(SELECT SUM(brand_importance) FROM market_research),1) AS brand_importance_percentage 
FROM market_research 
GROUP BY segment
ORDER BY SUM(brand_importance) DESC
;

-- Service preference percentage by market segment
SELECT segment, 
        SUM(service_importance) as service_importance, 
        ROUND(SUM(service_importance) *100.0/(SELECT SUM(service_importance) FROM market_research),1) AS service_importance_percentage 
FROM market_research 
GROUP BY segment 
ORDER BY SUM(service_importance) DESC
;

-- Price sensitivity preference percentage by market segment
SELECT segment, 
        SUM(price_sensitivity) as price_sensitivity, 
        ROUND(SUM(price_sensitivity) *100.0/(SELECT SUM(price_sensitivity) FROM market_research),1) AS price_sensitivity_percentage 
FROM market_research 
GROUP BY segment 
ORDER BY SUM(price_sensitivity) DESC
;

-- Calculating competitor consideration percentage by market research
SELECT competitor_consideration, 
        COUNT(competitor_consideration) as competitor_count, 
        ROUND(COUNT(competitor_consideration)*100.0/(SELECT COUNT(competitor_consideration) FROM market_research),1) AS competitor_consideration_percentage
FROM market_research 
GROUP BY competitor_consideration 
ORDER BY competitor_count DESC
;


