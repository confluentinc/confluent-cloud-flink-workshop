INSERT INTO page_statistics_daily
SELECT
    CAST(null AS VARBINARY) AS `key`,
    window_time,
    url,
    AVG(view_time) AS avg_view_time,
    COUNT(DISTINCT user_id) AS unique_users
FROM TABLE(TUMBLE((
                      SELECT *, $rowtime
                      FROM clicks
                      /*+ OPTIONS(
                          'scan.startup.mode' = 'specific-offsets',
                          'scan.startup.specific-offsets' = '${clicks_offsets}'
                      )*/
                  ), DESCRIPTOR(`$rowtime`), INTERVAL '1' DAY))
GROUP BY url, window_end, window_start, window_time;