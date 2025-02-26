INSERT INTO page_statistics_daily
SELECT 
  CAST(null AS VARBINARY) AS `key`,
  window_time,
  url,
  AVG(view_time) AS avg_view_time,
  COUNT(DISTINCT user_id) AS unique_users
FROM TABLE(TUMBLE(TABLE clicks, DESCRIPTOR(`$rowtime`), INTERVAL '1' DAY))
GROUP BY url, window_end, window_start, window_time;