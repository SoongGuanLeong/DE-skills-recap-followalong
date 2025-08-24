-- aggregate need to pair with group by
SELECT
  Month(order_date) AS order_month, 
  product_category,
  COUNT(order_id) AS total_orders
FROM orders_ext
GROUP BY 
  1,2
ORDER BY 
  1,
  3 DESC