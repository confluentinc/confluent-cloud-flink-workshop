CREATE TABLE order_status (
  order_id STRING, 
  order_status STRING, 
  update_time TIMESTAMP_LTZ(3) METADATA FROM 'timestamp',
  WATERMARK FOR update_time AS update_time - INTERVAL '3' MINUTES,
  PRIMARY KEY (order_id) NOT ENFORCED
) DISTRIBUTED BY HASH(order_id) INTO 2 BUCKETS