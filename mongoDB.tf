module "MongoDB_CurrentConnections_Cluster_isvmongo-zee5-prod-payments" {
  source           = "./modules/lbDetectors/"
  application_name = "isvmongo-zee5-prod-payments"
  metric_label     = "currentConnections"
  alert_name       = "MongoDBCurrentConnections"
  display_unit     = null
  email_list       = ["Email,mayank.gupta@gssltd.co.in"]
  critical_description = "Current connections to mongo cluster is greater than 1500 for last 5 min"
  splunk_query     = <<-EOF
          A = data('mongodb_connections_current', filter=filter('cl_name', 'isvmongo-zee5-prod-payments') and filter('rs_state', '*')).sum(by=['cl_name']).publish(label='currentConnections')
          detect(when(A > 1500,'5m',1.0), mode='split').publish('MongoDBCurrentConnections_Critical')
      EOF
  custom_email_body = null
  critical_detector = "true"
}

module "MongoDB_ReadLatency_Cluster_isvmongo-zee5-prod-payments" {
  source           = "./modules/lbDetectors/"
  application_name = "isvmongo-zee5-prod-payments"
  metric_label     = "latency"
  alert_name       = "MongoDBReadLatency"
  display_unit     = "Microsecond"
  email_list       = ["Email,mayank.gupta@gssltd.co.in"]
  critical_description = "Read latency is greater than 5ms for last 5 min"
  splunk_query     = <<-EOF
          B = data('mongodb_opLatencies_reads_latency', filter=filter('rs_state', '*') and filter('cl_name', 'isvmongo-zee5-prod-payments'), rollup='max').rateofchange().sum(by=['cl_name']).publish(label='B', enable=False)
          C = data('mongodb_opLatencies_reads_ops', filter=filter('rs_state', '*') and filter('cl_name', 'isvmongo-zee5-prod-payments'), rollup='max').rateofchange().sum(by=['cl_name']).publish(label='C', enable=False)
          D = combine((B if B is not None else 0)/(C if C is not None else 1)).publish(label='latency')
          detect(when(D > 5000,'5m',1.0), mode='split').publish('MongoDBReadLatency_Critical')
      EOF
  custom_email_body = null
  critical_detector = "true"
}

module "MongoDB_WriteLatency_Cluster_isvmongo-zee5-prod-payments" {
  source           = "./modules/lbDetectors/"
  application_name = "isvmongo-zee5-prod-payments"
  metric_label     = "latency"
  alert_name       = "MongoDBWriteLatency"
  display_unit     = "Microsecond"
  email_list       = ["Email,mayank.gupta@gssltd.co.in"]
  critical_description = "Write latency is greater than 5ms for last 5 min"
  splunk_query     = <<-EOF
          B = data('mongodb_opLatencies_writes_latency', filter=filter('rs_state', '*') and filter('cl_name', 'isvmongo-zee5-prod-payments'), rollup='max').rateofchange().sum(by=['cl_name']).publish(label='B', enable=False)
          C = data('mongodb_opLatencies_writes_ops', filter=filter('rs_state', '*') and filter('cl_name', 'isvmongo-zee5-prod-payments'), rollup='max').rateofchange().sum(by=['cl_name']).publish(label='C', enable=False)
          D = combine((B if B is not None else 0)/(C if C is not None else 1)).publish(label='latency')
          detect(when(D > 5000,'5m',1.0), mode='split').publish('MongoDBWriteLatency_Critical')
      EOF
  custom_email_body = null
  critical_detector = "true"
}

module "MongoDB_NormalizedCPUUtilization_Cluster_isvmongo-zee5-prod-payments" {
  source           = "./modules/lbDetectors/"
  application_name = "isvmongo-zee5-prod-payments"
  metric_label     = "UtilizationPercentage"
  alert_name       = "MongoDBCPUUtilizationUser"
  display_unit     = null
  email_list       = ["Email,mayank.gupta@gssltd.co.in"]
  critical_description = "Normalized System cpu - user is greater than 80% for last 5 min"
  splunk_query     = <<-EOF
          A = data('hardware_system_cpu_user_milliseconds',filter=filter('sf_environment', 'PROD') and filter('cl_name', 'isvmongo-zee5-prod-payments')).sum(by=['net.host.name']).rateofchange().scale(0.1).abs().publish(label='A', enable=False)
          B = data('hardware_platform_num_logical_cpus',filter=filter('sf_environment', 'PROD') and filter('cl_name', 'isvmongo-zee5-prod-payments')).sum(by=['net.host.name']).publish(label='B', enable=False)
          C = combine(((A if A is not None else 0)/B)).publish(label='UtilizationPercentage')
          detect(when(C > 80,'5m',1.0), mode='split').publish('MongoDBCPUUtilizationUser_Critical')
      EOF
  custom_email_body = null
  critical_detector = "true"
}

module "MongoDB_SystemDiskFreePercentage_Cluster_isvmongo-zee5-prod-payments" {
  source           = "./modules/lbDetectors/"
  application_name = "isvmongo-zee5-prod-payments"
  metric_label     = "FreePercentage"
  alert_name       = "MongoDBSystemDiskFreePercent"
  display_unit     = null
  email_list       = ["Email,mayank.gupta@gssltd.co.in"]
  critical_description = "System disk free percentage is less than 10% for last 5 min"
  splunk_query     = <<-EOF
          A = data('hardware_disk_metrics_disk_space_free_bytes', filter=filter('sf_environment', '*') and filter('cl_name', 'isvmongo-zee5-prod-payments')).sum(by=['net.host.name']).publish(label='A', enable=False)
          B = data('hardware_disk_metrics_disk_space_used_bytes', filter=filter('sf_environment', '*') and filter('cl_name', 'isvmongo-zee5-prod-payments')).sum(by=['net.host.name']).publish(label='B', enable=False)
          C = (A*100/(A+B)).publish(label='FreePercentage')
          detect(when(C < 10,'5m',1.0), mode='split').publish('MongoDBSystemDiskFreePercent_Critical')
      EOF
  custom_email_body = null
  critical_detector = "true"
}