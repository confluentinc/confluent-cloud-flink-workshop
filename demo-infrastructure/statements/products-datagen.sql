CREATE TABLE `products` (
  product_id STRING, 
  name STRING, 
  brand STRING,
  vendor STRING,
  department STRING,
  PRIMARY KEY (product_id) NOT ENFORCED
) DISTRIBUTED BY HASH(product_id) INTO 4 BUCKETS
AS SELECT product_id, name, brand, vendor, department FROM `examples`.`marketplace`.products;