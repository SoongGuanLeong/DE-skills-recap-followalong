SELECT * FROM
  (SELECT * FROM
    (SELECT
      Month(order_date) AS order_month, 
      product_category,
      COUNT(order_id) AS total_orders
    FROM orders_ext
    GROUP BY 1,2
    ORDER BY 1, 3 DESC) AS table1
  WHERE product_category = 'Home Decor') AS table2
WHERE order_month = 5