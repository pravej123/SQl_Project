 -- 1. Identify the Top 10 Customers by Total Order Value
 SELECT 
    c.customer_id,
    c.customer_name,
    SUM(o.order_total) AS total_order_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_order_value DESC
LIMIT 10;

-- 2. Count the number of customers in each segment (Premium, Regular, Inactive, New)
SELECT 
    customer_segment,
    COUNT(*) AS customer_count
FROM customers
GROUP BY customer_segment;

-- 3. Find customers with an average order value above 500 and more than 10 orders
select customer_id,customer_name, avg_order_value,total_orders
from customers
where avg_order_value>=500
and total_orders>=10;

-- 4. List orders that were delivered late along with reasons for delay.
SELECT 
    dp.order_id,
    o.customer_id,
    c.customer_name,
    dp.promised_time,
    dp.actual_time,
    dp.delivery_status,
    dp.reasons_if_delayed
FROM delivery_performance dp
JOIN orders o ON dp.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
WHERE dp.delivery_status IN ('slightly delayed', 'significantly delayed');

-- 5. Calculate the average delivery time (in minutes) per delivery partner.
SELECT 
    delivery_partner_id,
    ROUND(AVG(TIMESTAMPDIFF(MINUTE, promised_time, actual_time)), 2) AS avg_delivery_delay_minutes
FROM delivery_performance
GROUP BY delivery_partner_id;

-- 6. Find the top 5 stores by total order revenue.
SELECT 
    store_id,
    ROUND(SUM(order_total), 2) AS total_revenue
FROM orders
GROUP BY store_id
ORDER BY total_revenue DESC
LIMIT 5;

 -- 7. Identify products that have had damaged stock more than 5 times in total
 SELECT 
    p.product_id,
    p.product_name,
    SUM(i.damaged_stock) AS total_damaged
FROM inventory i
JOIN products p ON i.product_id = p.product_id
GROUP BY p.product_id, p.product_name
HAVING total_damaged > 5;

 -- 8. Calculate the total quantity ordered for each product
 SELECT 
    p.product_id,
    p.product_name,
    SUM(oi.quantity) AS total_quantity_ordered
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_quantity_ordered DESC;

 -- 9. Find products that often fall below the minimum stock level (compare current stock with min stock)
 SELECT 
    products.product_id, 
    products.product_name,
    SUM(order_items.quantity) AS current_quantity, 
    SUM(min_stock_level) AS min_stock
FROM products 
LEFT JOIN order_items ON products.product_id = order_items.product_id
GROUP BY products.product_id, products.product_name
HAVING SUM(order_items.quantity) < SUM(min_stock_level);

-- 10. calculate total revenue generated and roas for each marketing campaign.
select campaign_name, sum(revenue_generated) AS total_revenue,
sum(spend) as total_spend,
(sum(revenue_generated) / sum(spend)) as campaign_roas
from marketing_performance
group by campaign_name;

 -- 11. Find the campaign with the highest conversion rate
 select campaign_name,
sum(conversions) AS total_conversions,
sum(impressions) AS total_impressions,
(sum(conversions) / sum(impressions)) AS conversion_rate
from marketing_performance
group by campaign_name
ORDER BY conversion_rate DESC
LIMIT 1;

-- 12. List all campaigns targeted at Premium customers with performance metrics
SELECT 
    campaign_id,
    campaign_name,
    impressions,
    conversions,
    ROUND((conversions / impressions) * 100, 2) AS conversion_rate,
    spend
FROM marketing_performance
WHERE target_audience = 'Premium';

-- 13. Count feedback entries by sentiment (Positive, Neutral, Negative)
SELECT 
    sentiment,
    COUNT(*) AS feedback_count
FROM customer_feedback
GROUP BY sentiment;

-- 14. List customers who gave negative feedback with their orders
SELECT 
    cf.customer_id,
    c.customer_name,
    cf.order_id,
    cf.sentiment,
    cf.feedback_text
FROM customer_feedback cf
JOIN customers c ON cf.customer_id = c.customer_id
WHERE sentiment = 'Negative';

