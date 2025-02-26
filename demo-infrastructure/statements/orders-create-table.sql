CREATE TABLE `orders` (
  order_id STRING, 
  customer_id INT, 
  product_id STRING,
  price DOUBLE,
  PRIMARY KEY (order_id) NOT ENFORCED
) DISTRIBUTED BY HASH(order_id) INTO 2 BUCKETS
WITH (
 'changelog.mode' = 'append'
)