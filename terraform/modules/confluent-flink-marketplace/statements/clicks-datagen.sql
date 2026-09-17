CREATE TABLE `clicks` (
  click_id STRING, 
  user_id INT, 
  url STRING,
  user_agent STRING,
  view_time INT, 
  PRIMARY KEY (click_id) NOT ENFORCED
) DISTRIBUTED BY HASH(click_id) INTO 4 BUCKETS
WITH (
    'changelog.mode' = 'append'
)
AS SELECT click_id, user_id, url, user_agent, view_time FROM `examples`.`marketplace`.clicks;