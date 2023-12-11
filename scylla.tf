module "Scylla_Instance_Free_Disk_Space_Root_Partition" {
  source           = "./modules/lbDetectors/"
  application_name = "scylla-cloud-instance"
  metric_label     = "FreeSpace"
  alert_name       = "ScyllaFreeDiskSpaceRootPartition"
  display_unit     = null
  display_unit_suffix = "%"
  email_list       = ["Email,mayank.gupta@gssltd.co.in"]
  critical_description = "The scylla instance has less than 20% free disk space on the root partition"
  splunk_query     = <<-EOF
		A = data('scylla_node_filesystem_avail_bytes', filter=filter('sf_environment', '*') and filter('mountpoint', '/') and filter('by', 'instance')).sum(by=['exported_instance']).publish(label='A', enable=False)
		B = data('scylla_node_filesystem_size_bytes', filter=filter('sf_environment', '*') and filter('mountpoint', '/') and filter('by', 'instance')).sum(by=['exported_instance']).publish(label='B', enable=False)
		C = ((A*100)/B).publish(label='FreeSpace')
		detect(when(C < 20,'3m',1.0), mode='split').publish('ScyllaFreeDiskSpaceRootPartition_Critical')
    EOF
  custom_email_body = null
  critical_detector = "true"
}

module "Scylla_Instance_Average_Read_Latency" {
  source           = "./modules/lbDetectors/"
  application_name = "scylla-cloud-instance"
  metric_label     = "AvgReadLatency"
  alert_name       = "ScyllaInstanceAvgReadLatency"
  display_unit     = "Microsecond"
  display_unit_suffix = null
  email_list       = ["Email,mayank.gupta@gssltd.co.in"]
  critical_description = "The average read latency is more than 100 ms for last 3 minutes"
  splunk_query     = <<-EOF
		A = data('rlatencya', filter=filter('sf_environment', '*') and filter('by', 'instance')).publish(label='AvgReadLatency')
		detect(when(A > 100000,'3m',1.0), mode='split').publish('ScyllaInstanceAvgReadLatency_Critical')
    EOF
  custom_email_body = null
  critical_detector = "true"
}

module "Scylla_Instance_Average_Write_Latency" {
  source           = "./modules/lbDetectors/"
  application_name = "scylla-cloud-instance"
  metric_label     = "AvgWriteLatency"
  alert_name       = "ScyllaInstanceAvgWriteLatency"
  display_unit     = "Microsecond"
  display_unit_suffix = null
  email_list       = ["Email,mayank.gupta@gssltd.co.in"]
  critical_description = "The average write latency is more than 100 ms for last 3 minutes"
  splunk_query     = <<-EOF
		A = data('wlatencya', filter=filter('sf_environment', '*') and filter('by', 'instance')).publish(label='AvgWriteLatency')
		detect(when(A > 100000,'3m',1.0), mode='split').publish('ScyllaInstanceAvgWriteLatency_Critical')
    EOF
  custom_email_body = null
  critical_detector = "true"
}