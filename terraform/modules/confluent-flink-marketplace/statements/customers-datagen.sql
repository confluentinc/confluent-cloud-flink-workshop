CREATE TABLE `customers` (
  customer_id INT, 
  name STRING, 
  address STRING,
  postcode STRING,
  city STRING, 
  email STRING,
  PRIMARY KEY (customer_id) NOT ENFORCED
) DISTRIBUTED BY HASH(customer_id) INTO 2 BUCKETS
AS SELECT customer_id, name, address, postcode, city, email 
FROM `examples`.`marketplace`.customers;