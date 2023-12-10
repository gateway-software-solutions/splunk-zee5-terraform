module "Spanner_RequestRate_Instance_zee5-prod-primary-multi-region" {
  source           = "./modules/lbDetectors/"
  application_name = "spanner-zee5-prod-primary-multi-region"
  metric_label     = "RequestPerSec"
  alert_name       = "SpannerAPIRequestRateForInstance"
  display_unit     = null
  email_list       = ["Email,mayank.gupta@gssltd.co.in"]
  critical_description = "The request rate is greater than 100 per sec for last 5 min"
  splunk_query     = <<-EOF
          A = data('api/request_count', filter=filter('status', '*') and filter('database', '*') and filter('instance_id', 'spanner-zee5-prod-primary-multi-region') and filter('project_id', '*') and filter('monitored_resource', 'spanner_instance')).sum(by=['instance_id']).publish(label='RequestPerSec')
          detect(when(A > 100,'5m',1.0), mode='split').publish('SpannerAPIRequestRateForInstance_Critical')
      EOF
  custom_email_body = null
  critical_detector = "true"
  delay_in_sec = 300
}

module "Spanner_StorageUtilized_Instance_zee5-prod-primary-multi-region" {
  source           = "./modules/lbDetectors/"
  application_name = "spanner-zee5-prod-primary-multi-region"
  metric_label     = "Utilization"
  alert_name       = "SpannerStorageUtilized"
  display_unit     = null
  display_unit_suffix = "%"
  email_list       = ["Email,mayank.gupta@gssltd.co.in"]
  critical_description = "The storage utilization for spanner instance is greater than 80% for last 5 min"
  splunk_query     = <<-EOF
          A = data('instance/storage/utilization', filter=filter('instance_id', 'spanner-zee5-prod-primary-multi-region') and filter('project_id', '*') and filter('monitored_resource', 'spanner_instance')).sum(by=['instance_id']).publish(label='Utilization')
          detect(when((A*100) > 80,'5m',1.0), mode='split').publish('SpannerStorageUtilized_Critical')
      EOF
  custom_email_body = null
  critical_detector = "true"
  delay_in_sec = 300
}

module "Spanner_CPUUtilization_Instance_zee5-prod-primary-multi-region" {
  source           = "./modules/lbDetectors/"
  application_name = "spanner-zee5-prod-primary-multi-region"
  metric_label     = "Utilization"
  alert_name       = "SpannerCPUUtilization"
  display_unit     = null
  display_unit_suffix = "%"
  email_list       = ["Email,mayank.gupta@gssltd.co.in"]
  critical_description = "The cpu utilization for spanner instance is greater than 80% for last 5 min"
  splunk_query     = <<-EOF
          A = data('instance/cpu/utilization', filter=filter('instance_id', 'spanner-zee5-prod-primary-multi-region') and filter('project_id', '*') and filter('monitored_resource', 'spanner_instance')).sum(by=['instance_id']).publish(label='Utilization')
          detect(when((A*100) > 80,'5m',1.0), mode='split').publish('SpannerCPUUtilization_Critical')
      EOF
  custom_email_body = null
  critical_detector = "true"
  delay_in_sec = 300
}

module "Spanner_QueryLatency_Database_payment" {
  source           = "./modules/lbDetectors/"
  application_name = "spanner-database-payment"
  metric_label     = "AvgLatency"
  alert_name       = "SpannerDBLatency"
  display_unit     = "Second"
  email_list       = ["Email,mayank.gupta@gssltd.co.in"]
  critical_description = "The average latency for database is greater than 800ms for last 5 min"
  splunk_query     = <<-EOF
          A = data('query_stat/total/query_latencies', filter=filter('instance_id', '*') and filter('database', 'payment') and filter('monitored_resource', 'spanner_instance') and filter('project_id', '*')).sum(by=['database']).publish(label='A', enable=False)
          B = data('query_stat/total/query_latencies.count', filter=filter('instance_id', '*') and filter('database', 'payment') and filter('monitored_resource', 'spanner_instance') and filter('project_id', '*')).sum(by=['database']).publish(label='B', enable=False)
          C = (A/B).publish(label='AvgLatency')
          detect(when((C*1000) > 500,'5m',1.0), mode='split').publish('SpannerDBLatency_Critical')
      EOF
  custom_email_body = null
  critical_detector = "true"
  delay_in_sec = 300
}

module "Spanner_RequestRate_Database_payment" {
  source           = "./modules/lbDetectors/"
  application_name = "spanner-database-payment"
  metric_label     = "RequestPerSec"
  alert_name       = "SpannerAPIRequestRateForDatabase"
  display_unit     = null
  display_unit_suffix = "/s"
  email_list       = ["Email,mayank.gupta@gssltd.co.in"]
  critical_description = "The request rate is greater than 100 per sec for last 5 min"
  splunk_query     = <<-EOF
          A = data('api/request_count', filter=filter('status', '*') and filter('database', 'payment') and filter('instance_id', '*') and filter('project_id', '*') and filter('monitored_resource', 'spanner_instance')).sum(by=['database']).publish(label='RequestPerSec')
          detect(when(A > 100,'5m',1.0), mode='split').publish('SpannerAPIRequestRateForDatabase_Critical')
      EOF
  custom_email_body = null
  critical_detector = "true"
  delay_in_sec = 300
}