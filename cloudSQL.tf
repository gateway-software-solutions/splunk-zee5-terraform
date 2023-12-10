module "CloudSQL_NetworkConnections_Database_zee5-prod-mysql-adtech" {
  source           = "./modules/lbDetectors/"
  application_name = "clsql-zee5-prod-mysql-adtech"
  metric_label     = "Connections"
  alert_name       = "CloudSQLNetworkConnectionCount"
  display_unit     = null
  email_list       = ["Email,mayank.gupta@gssltd.co.in"]
  critical_description = "The number of connections to the database is more than 100 for last 5 min"
  splunk_query     = <<-EOF
          A = data('database/network/connections', filter=filter('database_id', '*clsql-zee5-prod-mysql-adtech') and filter('project_id', '*')).sum(by=['database_id']).publish(label='Connections')
          detect(when(A > 100,'5m',1.0), mode='split').publish('CloudSQLNetworkConnectionCount_Critical')
      EOF
  custom_email_body = null
  critical_detector = "true"
  delay_in_sec = 300
}

module "CloudSQL_MemoryUtilization_Database_zee5-prod-mysql-adtech" {
  source           = "./modules/lbDetectors/"
  application_name = "clsql-zee5-prod-mysql-adtech"
  metric_label     = "Utilization"
  alert_name       = "CloudSQLMemoryUtilization"
  display_unit     = null
  display_unit_suffix = "%"
  email_list       = ["Email,mayank.gupta@gssltd.co.in"]
  critical_description = "The memory utilization of the database is more than 90% for last 5 min"
  splunk_query     = <<-EOF
          A = data('database/memory/utilization', filter=filter('project_id', '*') and filter('database_id', '*clsql-zee5-prod-mysql-adtech')).sum(by=['database_id']).scale(100).publish(label='Utilization')
          detect(when(A > 90,'5m',1.0), mode='split').publish('CloudSQLMemoryUtilization_Critical')
      EOF
  custom_email_body = null
  critical_detector = "true"
  delay_in_sec = 300
}

module "CloudSQL_CPUUtilization_Database_zee5-prod-mysql-adtech" {
  source           = "./modules/lbDetectors/"
  application_name = "clsql-zee5-prod-mysql-adtech"
  metric_label     = "Utilization"
  alert_name       = "CloudSQLCPUUtilization"
  display_unit     = null
  display_unit_suffix = "%"
  email_list       = ["Email,mayank.gupta@gssltd.co.in"]
  critical_description = "The cpu utilization of the database is more than 90% for last 5 min"
  splunk_query     = <<-EOF
          A = data('database/cpu/utilization', filter=filter('project_id', '*') and filter('database_id', '*clsql-zee5-prod-mysql-adtech')).sum(by=['database_id']).scale(100).publish(label='Utilization')
          detect(when(A > 90,'5m',1.0), mode='split').publish('CloudSQLCPUUtilization_Critical')
      EOF
  custom_email_body = null
  critical_detector = "true"
  delay_in_sec = 300
}

module "CloudSQL_ReplicationLag_Database_zee5-prod-mysql-adtech" {
  source           = "./modules/lbDetectors/"
  application_name = "clsql-zee5-prod-mysql-adtech-replica"
  metric_label     = "ReplicationLag"
  alert_name       = "CloudSQLReplicationLag"
  display_unit     = "Second"
  display_unit_suffix = null
  email_list       = ["Email,mayank.gupta@gssltd.co.in"]
  critical_description = "The replica is lagging behind by more than 10 seconds for last 5 min"
  splunk_query     = <<-EOF
          A = data('database/replication/replica_lag', filter=filter('project_id', '*') and filter('database_id', '*clsql-zee5-prod-mysql-adtech-replica')).sum(by=['database_id']).publish(label='ReplicationLag')
          detect(when(A > 10,'5m',1.0), mode='split').publish('CloudSQLReplicationLag_Critical')
      EOF
  custom_email_body = null
  critical_detector = "true"
  delay_in_sec = 300
}