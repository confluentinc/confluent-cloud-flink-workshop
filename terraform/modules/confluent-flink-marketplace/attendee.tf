# Attendee login access — grants the workshop attendee EnvironmentAdmin on their
# own environment so they can sign into the Confluent Cloud UI (the labs use
# confluent.cloud/go/flink). Gated on confluent_cloud_email so the module still
# applies for a plain single-tenant run where no attendee identity is supplied.

data "confluent_user" "attendee" {
  count = var.confluent_cloud_email != "" ? 1 : 0
  email = var.confluent_cloud_email
}

resource "confluent_role_binding" "attendee-env-admin" {
  count       = var.confluent_cloud_email != "" ? 1 : 0
  principal   = "User:${data.confluent_user.attendee[0].id}"
  role_name   = "EnvironmentAdmin"
  crn_pattern = confluent_environment.env.resource_name
}
