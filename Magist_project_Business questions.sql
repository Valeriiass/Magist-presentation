-- 3.1.1 What categories of tech products does Magist have?
    
    SELECT
    pt.product_category_name_english
    FROM 
    order_items o
    LEFT JOIN 
    products p ON o.product_id = p.product_id
    LEFT JOIN product_category_name_translation pt ON p.product_category_name = pt.product_category_name
    WHERE 
    pt.product_category_name_english IN ('computers','electronics',
        'consoles_games',
        'fixed_telephony',
        'audio',
        'cine_photo')
    GROUP BY pt.product_category_name_english;
    
    
-- 3.1.2 How many products of these tech categories have been sold (time, procent) 
-- THIS ok 

 SELECT
    pt.product_category_name_english,
    COUNT(o.order_id) AS qty_items
    FROM 
    order_items o
    INNER JOIN 
    products p ON o.product_id = p.product_id
    INNER JOIN 
    product_category_name_translation pt ON p.product_category_name = pt.product_category_name
    WHERE 
    pt.product_category_name_english IN ('computers','electronics',
        'consoles_games',
        'fixed_telephony',
        'audio',
        'cine_photo')
    GROUP BY pt.product_category_name_english
    ORDER BY qty_items DESC;
    
-- all
 SELECT
  COUNT(product_id)
  FROM order_items;
  
  -- tech
  SELECT
  COUNT(oi.product_id)
  FROM order_items oi
  LEFT JOIN 
  products p ON oi.product_id = p.product_id
  LEFT JOIN 
  product_category_name_translation pt ON p.product_category_name = pt.product_category_name
  WHERE 
    pt.product_category_name_english IN ('computers','electronics',
        'consoles_games',
        'fixed_telephony',
        'audio',
        'cine_photo'); 
  
 -- result -- 4%
 SELECT ROUND((4807/112659) * 100);
    

-- 3.1.3 the average price of the products being sold (without tech)
SELECT 
    ROUND(AVG(o.price))
FROM
    order_items o
        LEFT JOIN
    products p ON o.product_id = p.product_id
        LEFT JOIN
    product_category_name_translation pt ON p.product_category_name = pt.product_category_name;
    
-- tech 
SELECT 
    ROUND(AVG(o.price))
FROM
    order_items o
        LEFT JOIN
    products p ON o.product_id = p.product_id
        LEFT JOIN
    product_category_name_translation pt ON p.product_category_name = pt.product_category_name
    WHERE 
    pt.product_category_name_english IN ('computers','electronics',
        'consoles_games',
        'fixed_telephony',
        'audio',
        'cine_photo');
    
-- 3.1.4 Are expensive tech products popular? 
-- In this code I was add 1 category with LIKE function, but only with 1. How I can to add another words in LIKE function ?
SELECT 
DISTINCT COUNT(o.product_id),
CASE 
WHEN price > 2500 THEN 'expensive_items' 
WHEN price > 500 THEN 'middle_price_items'
ELSE 'low_price_items'
END AS price_category_of_items
FROM 
order_items o
        LEFT JOIN
    products p ON o.product_id = p.product_id
        LEFT JOIN
    product_category_name_translation pt ON p.product_category_name = pt.product_category_name
WHERE 
    pt.product_category_name_english IN ('computers','electronics',
        'consoles_games',
        'fixed_telephony',
        'audio',
        'cine_photo')
GROUP BY price_category_of_items
ORDER BY COUNT(product_id) DESC;

-- result not popular 


-- 3.2.1 How many months of data are included in the magist database?
-- All months together or How long database ?

-- statistics abiut monthes 
SELECT 
    COUNT(customer_id), MONTH(order_purchase_timestamp) AS month
FROM
    orders
GROUP BY month;

-- my RIGHT 
SELECT
    COUNT(DISTINCT YEAR(order_purchase_timestamp),
        MONTH(order_purchase_timestamp)) AS num_rows
   FROM
   orders;
   
   -- Ali option - 
   SELECT 
   TIMESTAMPDIFF(MONTH,MIN(order_purchase_timestamp),MAX(order_purchase_timestamp))
   FROM 
   orders;

-- 3.2.2 
-- How many sellers are there?

SELECT 
COUNT(DISTINCT s.seller_id)
FROM 
sellers s
LEFT JOIN 
order_items o ON s.seller_id = o.seller_id
LEFT JOIN 
products p On o.product_id = p.product_id
LEFT JOIN 
product_category_name_translation cat ON p.product_category_name = cat.product_category_name;


-- How many Tech sellers are there? 
-- sellers in each tech category 
-- sellers in each TECH category

SELECT 
cat.product_category_name_english,
COUNT(s.seller_id)
FROM 
sellers s
LEFT JOIN 
order_items o ON s.seller_id = o.seller_id
LEFT JOIN 
products p On o.product_id = p.product_id
LEFT JOIN 
product_category_name_translation cat ON p.product_category_name = cat.product_category_name
WHERE 
    cat.product_category_name_english IN ('computers','electronics',
        'consoles_games',
        'fixed_telephony',
        'audio',
        'cine_photo')
GROUP BY cat.product_category_name_english
ORDER BY COUNT(s.seller_id) DESC;

-- tech sellers 

SELECT 
COUNT(DISTINCT s.seller_id) AS tech_sellers
FROM 
sellers s
LEFT JOIN 
order_items o ON s.seller_id = o.seller_id
LEFT JOIN 
products p On o.product_id = p.product_id
LEFT JOIN 
product_category_name_translation cat ON p.product_category_name = cat.product_category_name
WHERE 
    cat.product_category_name_english IN ('computers','electronics',
        'consoles_games',
        'fixed_telephony',
        'audio',
        'cine_photo');

-- What percentage of overall sellers are Tech sellers?
-- result 8% 
SELECT ROUND((261/3095) * 100);

-- 3.2.3 What is the total amount earned by all sellers? 

SELECT 
ROUND (SUM(oi.price)) AS total
FROM 
order_items oi 
LEFT JOIN 
orders o USING(order_id)
WHERE 
o.order_status NOT IN ('unavailable', 'cancaled');

-- What is the total amount earned by all Tech sellers?

SELECT 
ROUND (SUM(oi.price)) AS total
FROM 
order_items oi 
LEFT JOIN 
orders o USING(order_id)
LEFT JOIN 
products p On oi.product_id = p.product_id
LEFT JOIN 
product_category_name_translation cat ON p.product_category_name = cat.product_category_name
WHERE 
o.order_status NOT IN ('unavailable', 'cancaled') 
AND cat.product_category_name_english IN ('computers','electronics',
        'consoles_games',
        'fixed_telephony',
        'audio',
        'cine_photo');
        
 -- reseult 5 %
 SELECT ROUND((657880/13591644) * 100);
 
 -- 3.2.4 Can you work out the average monthly!!! income of all sellers? 
 -- in each month in year 
SELECT
YEAR(order_purchase_timestamp) AS years,
MONTH(order_purchase_timestamp) AS monthes,
round(sum(price)) AS avr_month_price
FROM
sellers
        LEFT JOIN
    order_items ON order_items.seller_id = sellers.seller_id
        LEFT JOIN
    products ON order_items.product_id = products.product_id
        LEFT JOIN
    product_category_name_translation ON
product_category_name_translation.product_category_name =
products.product_category_name
    left join
  orders on orders.order_id = order_items.order_id
group by years, monthes
order by years, monthes;

-- all monthes 
SELECT
ROUND(SUM(price)) AS avr_month_price
FROM
sellers
        LEFT JOIN
    order_items ON order_items.seller_id = sellers.seller_id
        LEFT JOIN
    products ON order_items.product_id = products.product_id
        LEFT JOIN
    product_category_name_translation ON
product_category_name_translation.product_category_name =
products.product_category_name
    left join
  orders on orders.order_id = order_items.order_id;
  -- sum/qty_categories/all_months
  SELECT 
  round(1349444/3095/25);
  
-- Can you work out the average monthly income of Tech sellers?
-- All incomes in every month and year 
SELECT
YEAR(order_purchase_timestamp) AS years,
MONTH(order_purchase_timestamp) AS monthes,
round(sum(price)) AS avr_month_price
FROM
sellers
        LEFT JOIN
    order_items ON order_items.seller_id = sellers.seller_id
        LEFT JOIN
    products ON order_items.product_id = products.product_id
        LEFT JOIN
    product_category_name_translation ON
product_category_name_translation.product_category_name =
products.product_category_name
    LEFT JOIN
  orders ON orders.order_id = order_items.order_id
  WHERE 
    product_category_name_translation.product_category_name_english IN ('computers','electronics',
        'consoles_games',
        'fixed_telephony',
        'audio',
        'cine_photo')
GROUP BY years, monthes
ORDER BY years, monthes;

-- AVG monthly income by Tech cat

SELECT
ROUND(SUM(price)) AS avr_month_price
FROM
sellers
        LEFT JOIN
    order_items ON order_items.seller_id = sellers.seller_id
        LEFT JOIN
    products ON order_items.product_id = products.product_id
        LEFT JOIN
    product_category_name_translation ON
product_category_name_translation.product_category_name =
products.product_category_name
    left join
  orders on orders.order_id = order_items.order_id
  WHERE 
    product_category_name_translation.product_category_name_english IN ('computers','electronics',
        'consoles_games',
        'fixed_telephony',
        'audio',
        'cine_photo');
  -- sum/qty_categories/all_months
  SELECT 
  round(657880/444/25);

-- 3.3.1 What’s the average time between the order being placed and the product being delivered?
    
    SELECT
    ROUND(AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)))
FROM
orders;

    
-- 3.3.2 How many orders are delivered on time vs orders delivered with a delay?

SELECT 
CASE
  WHEN
  DATEDIFF(order_estimated_delivery_date, order_delivered_customer_date) > 0 THEN 'On time'
  ELSE 'Delayed'
END AS delivery_status,
COUNT(order_id) AS order_count
FROM
orders
WHERE order_status = 'delivered'
GROUP BY delivery_status;
-- %
SELECT 
6673/(SELECT COUNT(order_id) 
FROM orders 
WHERE order_status = 'delivered')*100;


-- 3.3.3 
-- Is there any pattern for delayed orders, e.g. big products being delayed more often?

SELECT 
CASE 
    WHEN DATEDIFF(order_estimated_delivery_date, order_delivered_customer_date) > 100 THEN '> 100 days delay'
    WHEN DATEDIFF(order_estimated_delivery_date, order_delivered_customer_date) >= 8 AND DATEDIFF(order_estimated_delivery_date, order_delivered_customer_date) <= 100 THEN '8-100 days Delay'
    WHEN DATEDIFF(order_estimated_delivery_date, order_delivered_customer_date) > 3 AND DATEDIFF(order_estimated_delivery_date, order_delivered_customer_date) < 8 THEN ' 3-8 days Delay'
    WHEN DATEDIFF(order_estimated_delivery_date, order_delivered_customer_date) > 1 THEN '1 - 3 days Delay'
    ELSE ' <= 1 day delay '
END AS 'delay_range',
ROUND(AVG(product_weight_g)) AS weight_avg,    
ROUND(MAX(product_weight_g)) AS weight_max,
ROUND(MIN(product_weight_g)) AS weight_min,
ROUND(SUM(product_weight_g)) AS weight,
COUNT(*) AS product_count
FROM orders o
LEFT JOIN 
order_items oi USING(order_id)
LEFT JOIN products p USING (product_id)
WHERE DATEDIFF(order_estimated_delivery_date, order_delivered_customer_date) > 0
GROUP BY delay_range
ORDER BY weight_avg DESC;