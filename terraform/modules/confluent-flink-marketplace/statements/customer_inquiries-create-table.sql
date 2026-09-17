CREATE TABLE `customer_inquiries` (
  request_id STRING, 
  order_id STRING, 
  customer_id BIGINT,
  request_time TIMESTAMP_LTZ(3) METADATA FROM 'timestamp',
  WATERMARK FOR request_time AS request_time - INTERVAL '4' MINUTES, 
  PRIMARY KEY (request_id) NOT ENFORCED
) WITH (
  'changelog.mode' = 'append'
);