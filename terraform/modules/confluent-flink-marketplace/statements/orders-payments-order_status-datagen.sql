EXECUTE STATEMENT SET
BEGIN
INSERT INTO customer_inquiries
SELECT * FROM 
(SELECT 
 UUID() AS request_id, 
 order_id, 
 RAND_INTEGER(100000) AS customer_id,
 TIMESTAMPADD(SECOND, 240, `$rowtime`) AS request_time
FROM `examples`.`marketplace`.orders WHERE EXTRACT(MILLISECOND FROM `$rowtime`) > 950)
UNION ALL
(SELECT 
 UUID() AS request_id, 
 order_id, 
 RAND_INTEGER(100000) AS customer_id,
 TIMESTAMPADD(SECOND, 240, `$rowtime`) AS request_time
FROM  `examples`.`marketplace`.orders WHERE EXTRACT(MILLISECOND FROM `$rowtime`) > 950)
UNION ALL
(SELECT 
 UUID() AS request_id, 
 order_id, 
 RAND_INTEGER(100000) AS customer_id,
 TIMESTAMPADD(SECOND, 240, `$rowtime`) AS request_time
FROM  `examples`.`marketplace`.orders WHERE EXTRACT(MILLISECOND FROM `$rowtime`) > 950)
UNION ALL
(SELECT 
 UUID() AS request_id, 
 order_id, 
 RAND_INTEGER(100000) AS customer_id,
 TIMESTAMPADD(SECOND, 240, `$rowtime`) AS request_time
FROM  `examples`.`marketplace`.orders WHERE EXTRACT(MILLISECOND FROM `$rowtime`) > 950);
INSERT INTO `orders`
(SELECT order_id, customer_id, product_id, price FROM `examples`.`marketplace`.orders WHERE EXTRACT(MILLISECOND FROM `$rowtime`) > 950)
UNION ALL
(SELECT order_id, customer_id, product_id, price FROM `examples`.`marketplace`.orders WHERE EXTRACT(MILLISECOND FROM `$rowtime`) > 950 AND RAND() > 0.9);
INSERT INTO order_status
WITH order_fullfilment_base AS 
(SELECT 
  order_id, 
  32 AS payment_delay, 
  RAND_INTEGER(30) AS shipment_delay,
  RAND_INTEGER(90) AS delivery_delay, 
  `$rowtime`
FROM `examples`.`marketplace`.`orders` WHERE EXTRACT(MILLISECOND FROM `$rowtime`) > 950)
SELECT * 
FROM
  (SELECT order_id, 'CREATED' as order_status,`$rowtime` AS update_time FROM order_fullfilment_base)
  UNION ALL
  (SELECT order_id, 'PAID' as order_status, TIMESTAMPADD(SECOND, payment_delay, `$rowtime`) AS update_time FROM order_fullfilment_base)
  UNION ALL
  (SELECT order_id, 'SHIPPED' as order_status, TIMESTAMPADD(SECOND, payment_delay+shipment_delay, `$rowtime`) AS update_time FROM order_fullfilment_base)
  UNION ALL
  (SELECT order_id, 'DELIVERED' as order_status, TIMESTAMPADD(SECOND, payment_delay+shipment_delay+delivery_delay, `$rowtime`) AS update_time FROM order_fullfilment_base);
INSERT INTO `payments` 
SELECT 
  UUID() AS payment_id,
  order_id, 
  ARRAY['CREDIT','BANK_TRANSFER','WALLET','MOBILE', 'PREPAID', 'BTC'][RAND_INTEGER(6)+1] AS payment_method, 
  ROUND(price * RAND()*50,2) AS amount,
  ARRAY['EUR','USD','JPY','GBP', 'AUD', 'CAD', 'CHF' ,'CNH', 'HKD', 'NZD'][RAND_INTEGER(10)+1] AS currency, 
  TIMESTAMPADD(SECOND, 32, `$rowtime`)
FROM `examples`.`marketplace`.`orders` WHERE EXTRACT(MILLISECOND FROM `$rowtime`) > 950;
END;
