module "MongoDB_DatabaseCount" {
  source           = "./modules/lbDetectors/"
  application_name = "MongoDB"
  metric_label     = "DatabaseCount"
  alert_name       = "MongoDBCount"
  display_unit     = null
  email_list       = ["Email,mayank.gupta@gssltd.co.in"]
  critical_description = "The number of reporting mongo databases is less than 10 for last 5 min"
  splunk_query     = <<-EOF
          A = data('mongodb_up', filter=filter('sf_environment', 'PROD')).count().publish(label='DatabaseCount')
          detect(when(A < 10,'5m',1.0), mode='split').publish('MongoDBCount_Critical')
      EOF
  custom_email_body = null
  critical_detector = "true"
  delay_in_sec = 450
}

module "MongoDB_DatabaseStatus" {
  source           = "./modules/lbDetectors/"
  application_name = "MongoDB"
  metric_label     = "DatabaseStatus"
  alert_name       = "MongoDBStatus"
  display_unit     = null
  email_list       = ["Email,mayank.gupta@gssltd.co.in"]
  critical_description = "The mongo db cluster is down or not reporting for last 5 min"
  splunk_query     = <<-EOF
          A = data('mongodb_up', filter=filter('sf_environment', 'PROD'), extrapolation='zero').publish(label='DatabaseStatus')
          detect(when(A < 1,'5m',1.0), mode='split').publish('MongoDBStatus_Critical')
      EOF
  custom_email_body = null
  critical_detector = "true"
  delay_in_sec = 450
}

module "Redis_DatabaseCount" {
  source           = "./modules/lbDetectors/"
  application_name = "RedisEnterprise"
  metric_label     = "DatabaseCount"
  alert_name       = "RedisDBCount"
  display_unit     = null
  email_list       = ["Email,mayank.gupta@gssltd.co.in"]
  critical_description = "The number of reporting redis databases is less than 10 for last 5 min"
  splunk_query     = <<-EOF
          A = data('bdb_up', filter=filter('sf_environment', 'PROD')).count().publish(label='DatabaseCount')
          detect(when(A < 10,'5m',1.0), mode='split').publish('RedisDBCount_Critical')
      EOF
  custom_email_body = null
  critical_detector = "true"
  delay_in_sec = 450
}

module "Redis_DatabaseStatus" {
  source           = "./modules/lbDetectors/"
  application_name = "RedisEnterprise"
  metric_label     = "DatabaseStatus"
  alert_name       = "RedisDBStatus"
  display_unit     = null
  email_list       = ["Email,mayank.gupta@gssltd.co.in"]
  critical_description = "The redis database is down or not reporting for last 5 min"
  splunk_query     = <<-EOF
          A = data('bdb_up', filter=filter('sf_environment', 'PROD'), extrapolation='zero').publish(label='DatabaseStatus')
          detect(when(A < 1,'5m',1.0), mode='split').publish('RedisDBStatus_Critical')
      EOF
  custom_email_body = null
  critical_detector = "true"
  delay_in_sec = 450
}


module "CloudSQL_DatabaseCount" {
  source           = "./modules/lbDetectors/"
  application_name = "CloudSQL Database"
  metric_label     = "DatabaseCount"
  alert_name       = "CloudSQLDBCount"
  display_unit     = null
  email_list       = ["Email,mayank.gupta@gssltd.co.in"]
  critical_description = "The number of reporting cloudsql databases is less than 10 for last 5 min"
  splunk_query     = <<-EOF
          A = data('database/up', filter=filter('monitored_resource', 'cloudsql_database')).count().publish(label='DatabaseCount')
          detect(when(A < 10,'5m',1.0), mode='split').publish('CloudSQLDBCount_Critical')
      EOF
  custom_email_body = null
  critical_detector = "true"
  delay_in_sec = 450
}

module "CloudSQL_DatabaseStatus" {
  source           = "./modules/lbDetectors/"
  application_name = "CloudSQL Database"
  metric_label     = "DatabaseStatus"
  alert_name       = "CloudSQLDBStatus"
  display_unit     = null
  email_list       = ["Email,mayank.gupta@gssltd.co.in"]
  critical_description = "The cloudsql database is down for last 5 min"
  splunk_query     = <<-EOF
          A = data('database/up', filter=filter('monitored_resource', 'cloudsql_database'), extrapolation='zero').publish(label='DatabaseStatus')
          detect(when(A < 1,'5m',1.0), mode='split').publish('CloudSQLDBStatus_Critical')
      EOF
  custom_email_body = null
  critical_detector = "true"
  delay_in_sec = 450
}


module "Syclla_NodeCount" {
  source           = "./modules/lbDetectors/"
  application_name = "Scylla"
  metric_label     = "NodeCount"
  alert_name       = "ScyllaNodeCount"
  display_unit     = null
  email_list       = ["Email,mayank.gupta@gssltd.co.in"]
  critical_description = "The number of reporting scylla nodes is less than 10 for last 5 min"
  splunk_query     = <<-EOF
          A = data('scylla_node_operation_mode').count().publish(label='NodeCount')
          detect(when(A < 10,'5m',1.0), mode='split').publish('ScyllaNodeCount_Critical')
      EOF
  custom_email_body = null
  critical_detector = "true"
  delay_in_sec = 450
}

module "Syclla_NodeStatus" {
  source           = "./modules/lbDetectors/"
  application_name = "CloudSQL Database"
  metric_label     = "NodeStatus"
  alert_name       = "ScyllaNodeStatus"
  display_unit     = null
  email_list       = ["Email,mayank.gupta@gssltd.co.in"]
  critical_description = "The syclla node is down or not reporting for last 5 min"
  splunk_query     = <<-EOF
          A = data('scylla_node_operation_mode', extrapolation='zero').publish(label='NodeStatus')
          detect(when(A != 3,'5m',1.0), mode='split').publish('ScyllaNodeStatus_Critical')
      EOF
  custom_email_body = null
  critical_detector = "true"
  delay_in_sec = 450
}

module "Spanner_NodeCount" {
  source           = "./modules/lbDetectors/"
  application_name = "Spanner"
  metric_label     = "NodeCount"
  alert_name       = "SpannerNodeCount"
  display_unit     = null
  email_list       = ["Email,mayank.gupta@gssltd.co.in"]
  critical_description = "The number of reporting spanner nodes is less than 5 for last 5 min"
  splunk_query     = <<-EOF
          A = data('instance/node_count', filter=filter('project_id', '*prod*') and filter('monitored_resource', 'spanner_instance')).sum().publish(label='NodeCount')
          detect(when(A < 5,'5m',1.0), mode='split').publish('SpannerNodeCount_Critical')
      EOF
  custom_email_body = null
  critical_detector = "true"
  delay_in_sec = 450
}

module "Kafka_BrokerCount" {
  source           = "./modules/lbDetectors/"
  application_name = "Kafka"
  metric_label     = "BrokerCount"
  alert_name       = "KafkaBrokerCount"
  display_unit     = null
  email_list       = ["Email,mayank.gupta@gssltd.co.in"]
  critical_description = "The number of reporting Kafka brokers is less than 1 for last 5 min"
  splunk_query     = <<-EOF
          A = data('kafka.brokers', filter=filter('sf_environment', 'PROD')).count().publish(label='BrokerCount')
          detect(when(A < 1,'5m',1.0), mode='split').publish('KafkaBrokerCount_Critical')
      EOF
  custom_email_body = null
  critical_detector = "true"
  delay_in_sec = 120
}

module "Solr_LiveNodeMetric" {
  source           = "./modules/lbDetectors/"
  application_name = "Solr"
  metric_label     = "MetricCount"
  alert_name       = "SolrMetricCount"
  display_unit     = null
  email_list       = ["Email,mayank.gupta@gssltd.co.in"]
  critical_description = "The Solr live nodes count metric is not reporting for last 5 min"
  splunk_query     = <<-EOF
          A = data('solr_collections_live_nodes',extrapolation='zero').count().publish(label='MetricCount')
          detect(when(A < 1,'5m',1.0), mode='split').publish('SolrMetricCount_Critical')
      EOF
  custom_email_body = null
  critical_detector = "true"
  delay_in_sec = 120
}