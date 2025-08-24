SELECT 
price_per_unit,
RANK() over(ORDER BY price_per_unit DESC) as rank,
DENSE_RANK() over(ORDER BY price_per_unit DESC) as dense_rank,
ROW_NUMBER() over(ORDER BY price_per_unit DESC) as row_number
FROM orders_ext 