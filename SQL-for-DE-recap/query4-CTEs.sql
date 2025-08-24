WITH table1 (
SELECT 
  *,
  CASE
  WHEN payment_method LIKE '%Card%' AND (order_status IN ('Cancelled', 'Returned')) THEN 'CARD'
  WHEN payment_method IN ('UPI', 'PayPal') AND (order_status IN ('Cancelled', 'Returned')) THEN 'CASH'
  ELSE 'No Value'
  END Payment_flag
FROM orders_ext)
SELECT * FROM table1
WHERE Payment_flag = 'CARD'