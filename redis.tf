module "Redis_Process_CPU_Usage" {
  source           = "./modules/lbDetectors/"
  application_name = "redis-enterprise-cluster"
  metric_label     = "Utilization"
  alert_name       = "RedisEnterpriseProcessCPUUsage"
  display_unit     = null
  display_unit_suffix = "%"
  email_list       = ["Email,mayank.gupta@gssltd.co.in"]
  critical_description = "The cpu usage is more than 90% for last 5 min"
  splunk_query     = <<-EOF
          A = data('redis_process_cpu_usage_percent', filter=filter('sf_environment', '*') and filter('service.name', '*')).sum(by=['service.name']).publish(label='Utilization')
          detect(when(A > 90,'5m',1.0), mode='split').publish('RedisEnterpriseProcessCPUUsage_Critical')
      EOF
  custom_email_body = null
  critical_detector = "true"
}

module "Redis_Shard_Memory_Utilization" {
  source           = "./modules/lbDetectors/"
  application_name = "redis-enterprise-cluster"
  metric_label     = "Utilization"
  alert_name       = "RedisEnterpriseMemoryUsage"
  display_unit     = null
  display_unit_suffix = "%"
  email_list       = ["Email,mayank.gupta@gssltd.co.in"]
  critical_description = "The memory usage is more than 90% for last 5 min"
  splunk_query     = <<-EOF
          A = data('redis_used_memory', filter=filter('sf_environment', '*') and filter('service.name', '*')).sum(by=['service.name']).publish(label='A', enable=False)
          B = data('redis_maxmemory', filter=filter('sf_environment', '*') and filter('service.name', '*')).sum(by=['service.name']).publish(label='B', enable=False)
          C = ((A*100)/B).publish(label='Utilization')
          detect(when(C > 90,'5m',1.0), mode='split').publish('RedisEnterpriseMemoryUsage_Critical')
      EOF
  custom_email_body = null
  critical_detector = "true"
}

module "Redis_Cluster_Replication_Lag" {
  source           = "./modules/lbDetectors/"
  application_name = "redis-enterprise-cluster"
  metric_label     = "Lag"
  alert_name       = "RedisEnterpriseClusterReplicationLag"
  display_unit     = "Second"
  display_unit_suffix = null
  email_list       = ["Email,mayank.gupta@gssltd.co.in"]
  critical_description = "The replication lag is more than 100s for last 5 min"
  splunk_query     = <<-EOF
          A = data('redis_crdt_peer_lag', filter=filter('sf_environment', '*') and filter('cluster', '*'), rollup='latest').sum(by=['cluster']).publish(label='Lag')
          detect(when(A > 100,'5m',1.0), mode='split').publish('RedisEnterpriseClusterReplicationLag_Critical')
      EOF
  custom_email_body = null
  critical_detector = "true"
}

module "Redis_Database_ConnectionCount_isvredisdb-zee5-prod-adtech" {
  source           = "./modules/lbDetectors/"
  application_name = "isvredisdb-zee5-prod-adtech"
  metric_label     = "Connections"
  alert_name       = "RedisDatabaseConnections"
  display_unit     = null
  display_unit_suffix = null
  email_list       = ["Email,mayank.gupta@gssltd.co.in"]
  critical_description = "The number of connections to the database is more than 1000 for last 5 min"
  splunk_query     = <<-EOF
          A = data('bdb_conns', filter=filter('sf_environment', '*') and filter('cluster', '*') and filter('bdb_name', 'isvredisdb-zee5-prod-adtech') and filter('crdt_replica_id', '*'), rollup='average').sum(by=['bdb_name']).floor().publish(label='Connections')
          detect(when(A > 1000,'5m',1.0), mode='split').publish('RedisDatabaseConnections_Critical')
      EOF
  custom_email_body = null
  critical_detector = "true"
}

module "Redis_Database_MemoryUsedPercentage_isvredisdb-zee5-prod-adtech" {
  source           = "./modules/lbDetectors/"
  application_name = "isvredisdb-zee5-prod-adtech"
  metric_label     = "Used"
  alert_name       = "RedisDatabaseMemoryUsed"
  display_unit     = null
  display_unit_suffix = "%"
  email_list       = ["Email,mayank.gupta@gssltd.co.in"]
  critical_description = "The memory used percentage for the database is more than 90% for last 5 min"
  splunk_query     = <<-EOF
          A = data('bdb_used_memory', filter=filter('cluster', '*') and filter('bdb_name', 'isvredisdb-zee5-prod-adtech') and filter('crdt_replica_id', '*')).mean(by=['bdb_name']).publish(label='A', enable=False)
          B = data('bdb_memory_limit', filter=filter('cluster', '*') and filter('bdb_name', 'isvredisdb-zee5-prod-adtech') and filter('crdt_replica_id', '*')).mean(by=['bdb_name']).publish(label='B', enable=False)
          C = ((A*100)/B).publish(label='Used')
          detect(when(C > 90,'5m',1.0), mode='split').publish('RedisDatabaseMemoryUsed_Critical')
      EOF
  custom_email_body = null
  critical_detector = "true"
}