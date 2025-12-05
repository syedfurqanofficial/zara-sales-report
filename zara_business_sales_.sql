Create database business_sales;

use business_sales;

CREATE TABLE product_sales_2025 (
    `Product ID` INT PRIMARY KEY,
    `Product Position` VARCHAR(50),
    `Promotion` VARCHAR(100),
    `Product Category` VARCHAR(100),
    `Seasonal` VARCHAR(50),
    `Sales Volume` INT,
    `brand` VARCHAR(100),
    `url` VARCHAR(255),
    `name` VARCHAR(255),
    `description` TEXT,
    `price` DECIMAL(10,2),
    `currency` VARCHAR(10),
    `terms` TEXT,
    `section` VARCHAR(50),
    `season` VARCHAR(50),
    `material` VARCHAR(100),
    `origin` VARCHAR(100));

SELECT 
    COUNT('Product ID') AS total_products,
    SUM(`Sales Volume`) AS total_units_sold,
    SUM(`Sales Volume` * price) AS total_revenue,
    ROUND((price), 2) AS avg_price
FROM
    product_sales_2025;
    
    -- 2
    
SELECT 
   `Product ID`,
   name,
   SUM(`Sales Volume`) AS total_units_sold
FROM product_sales_2025
GROUP BY `Product ID`, name
ORDER BY total_units_sold asc
LIMIT 10;

-- 3

SELECT
   season,
   SUM(`Sales Volume`) AS units_sold
FROM product_sales_2025
GROUP BY season
ORDER BY units_sold DESC;

-- 4

SELECT
   Promotion,
   SUM(`Sales Volume`) AS units_sold
FROM product_sales_2025
GROUP BY Promotion
ORDER BY units_sold DESC;
 
 -- 5

SET @rank := 0;
SET @current_position := '';

SELECT ranked.*
FROM (
    SELECT 
        `Product ID`,
        name,
        `Product Position`,
        SUM(`Sales Volume`) AS units_sold,
        @rank := IF(@current_position = `Product Position`, @rank + 1, 1) AS rn,
        @current_position := `Product Position`
    FROM product_sales_2025
    WHERE `Product Position` = 'Aisle'
    GROUP BY `Product ID`, name, `Product Position`
    ORDER BY `Product Position`, SUM(`Sales Volume`) DESC
) AS ranked
WHERE rn <= 10 limit 10;

-- 6

SET @rank := 0;
SET @current_position := '';

SELECT ranked.*
FROM (
    SELECT 
        `Product ID`,
        name,
        `Product Position`,
        SUM(`Sales Volume`) AS units_sold,
        @rank := IF(@current_position = `Product Position`, @rank + 1, 1) AS rn,
        @current_position := `Product Position`
    FROM product_sales_2025
    WHERE `Product Position` = 'Front of Store'
    GROUP BY `Product ID`, name, `Product Position`
    ORDER BY `Product Position`, SUM(`Sales Volume`) DESC
) AS ranked
WHERE rn <= 10 limit 10;

-- 7

SELECT
   material,
   SUM(`Sales Volume`) AS units_sold
FROM product_sales_2025
GROUP BY material
ORDER BY units_sold DESC;

-- 8

SELECT
   origin,
   SUM(`Sales Volume`) AS units_sold
FROM product_sales_2025
GROUP BY origin
ORDER BY units_sold DESC;

-- 9

SELECT
   `Product ID`,
   name,
   price,
   SUM(`Sales Volume`) AS total_units_sold,
   (price * SUM(`Sales Volume`)) AS revenue
FROM product_sales_2025
GROUP BY `Product ID`, name, price
ORDER BY revenue DESC;

-- 9

SELECT
   `Product ID`,
   name,
   price,
   SUM(`Sales Volume`) AS total_units_sold,
   (price * SUM(`Sales Volume`)) AS revenue
FROM product_sales_2025
GROUP BY `Product ID`, name, price
ORDER BY revenue DESC;

-- 10

-- Step 1: Total revenue calculate karte hain
SELECT
    ps.`Product ID`,
    ps.name,
    ps.price,
    SUM(ps.`Sales Volume`) AS total_units_sold,
    SUM(ps.`Sales Volume` * ps.price) AS revenue,
    ROUND((SUM(ps.`Sales Volume` * ps.price) / total_rev.total_revenue) * 100, 2) AS revenue_percentage
FROM product_sales_2025 ps
-- Step 2: Filter products with price > 100
JOIN (SELECT SUM(price * `Sales Volume`) AS total_revenue FROM product_sales_2025) total_rev
WHERE ps.price > 130
GROUP BY ps.`Product ID`, ps.name, ps.price
ORDER BY revenue DESC;



