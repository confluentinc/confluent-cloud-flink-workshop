CREATE TABLE `payments` (
  payment_id STRING,
  order_id STRING, 
  payment_method STRING, 
  amount DOUBLE,
  currency STRING, 
  payment_time TIMESTAMP_LTZ(3) METADATA FROM 'timestamp', 
  WATERMARK FOR payment_time AS payment_time - INTERVAL '60' SECONDS,
  PRIMARY KEY (payment_id) NOT ENFORCED
) DISTRIBUTED BY HASH(payment_id) INTO 4 BUCKETS
WITH (
 'changelog.mode' = 'append'
)