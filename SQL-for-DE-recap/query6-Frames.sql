SELECT *,
SUM(price_per_unit) OVER(ORDER BY price_per_unit ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS total_order_value,
SUM(price_per_unit) OVER(ORDER BY price_per_unit ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
FROM orders_ext