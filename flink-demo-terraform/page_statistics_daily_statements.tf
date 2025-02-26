resource "confluent_flink_statement" "page_statistics_daily_v1" {
  properties = {
    "sql.current-catalog"  = "${var.env_name}"
    "sql.current-database" = "marketplace"
  }

  statement  = file("${path.module}/page_statistics_daily_v1.sql")
  statement_name = "page-statistics-daily-maintenance-v1"

  depends_on = [
    confluent_kafka_topic.page_statistics_daily,
    confluent_schema.page_statistics_daily_value_schema
  ]

  stopped = false
}

 # Step #2: Create page_statistics_daily_v2 and start from from v1 left off
# resource "confluent_flink_statement" "page_statistics_daily_v2" {
#   properties = {
#     "sql.current-catalog"  = "${var.env_name}"
#     "sql.current-database" = "marketplace"
#  }
#
#   statement = templatefile("${path.module}/page_statistics_daily_v2.sql",
#                {
#                  clicks_offsets = confluent_flink_statement.page_statistics_daily_v1.latest_offsets["clicks"]
#                }
#              )
#
#   statement_name = "page-statistics-daily-maintenance-v2"
#
#  depends_on = [
#    confluent_kafka_topic.page_statistics_daily,
#    confluent_schema.page_statistics_daily_value_schema
#  ]
# }


resource "confluent_kafka_topic" "page_statistics_daily" {

  topic_name    = "page_statistics_daily"

  partitions_count = 6
}

resource "confluent_schema" "page_statistics_daily_value_schema" {
  subject_name  = "${confluent_kafka_topic.page_statistics_daily.topic_name}-value"
  format        = "AVRO"
  schema        = file("${path.module}/page_statistics_daily-value.avsc")
}