module "UAT-Zee5-Singleapiplayback-4xx-Error-Rate" {
  source           = "./modules/detectors/"
  application_name = "zee5-singleplayback-api-uat"
  metric_label     = "4xxErrorPercent"
  alert_name       = "4xx_Error_%"
  display_unit     = null
  email_list       = ["Email,mayank.gupta@gssltd.co.in", "Email,mail@gssltd.co.in"]
  warning_description = "4xx error rate has been greater than 10% for last 3 minutes"
  critical_description = "4xx error rate has been greater than 12% for last 2 minutes"
  splunk_query     = <<-EOF
          filter_ = filter('sf_environment', 'UAT') and filter('sf_service', 'zee5-singleplayback-api-uat') and filter('sf_dimensionalized', 'true')
          A = data('service.request.count', filter=filter_ and filter('http_status_code', '4*'), rollup='delta').sum(by=['sf_environment', 'sf_service']).publish(label='A', enable=False)
          B = data('service.request.count', filter=filter_ and filter('http_status_code', '*'), rollup='delta').sum(by=['sf_environment', 'sf_service']).publish(label='B', enable=False)
          C = combine(100*((A if A is not None else 0) / B)).publish(label='4xxErrorPercent')
          detect(when(C > 10,'3m',1.0), mode='split').publish('4xx_Error_%_Warning')
          detect(when(C > 12,'2m',1.0), mode='split').publish('4xx_Error_%_Critical')
      EOF
  custom_email_body = null
  disable_detector  = "true"
}

module "UAT-Zee5-Singleapiplayback-5xx-Error-Rate" {
  source           = "./modules/detectors/"
  application_name = "zee5-singleplayback-api-uat"
  metric_label     = "5xxErrorPercent"
  alert_name       = "5xx_Error_%"
  display_unit     = null
  email_list       = ["Email,mayank.gupta@gssltd.co.in", "VictorOps,GBSvLbZCEAE,testing"]
  warning_description = "5xx error rate has been greater than 1% for last 3 minutes"
  critical_description = "5xx error rate has been greater than 2% for last 2 minutes"
  splunk_query     = <<-EOF
          filter_ = filter('sf_environment', 'UAT') and filter('sf_service', 'zee5-singleplayback-api-uat') and filter('sf_dimensionalized', 'true')
          A = data('service.request.count', filter=filter_ and filter('http_status_code', '5*'), rollup='delta').sum(by=['sf_environment', 'sf_service']).publish(label='A', enable=False)
          B = data('service.request.count', filter=filter_ and filter('http_status_code', '*'), rollup='delta').sum(by=['sf_environment', 'sf_service']).publish(label='B', enable=False)
          C = combine(100*((A if A is not None else 0) / B)).publish(label='5xxErrorPercent')
          detect(when(C > 1,'3m',1.0), mode='split').publish('5xx_Error_%_Warning')
          detect(when(C > 2,'2m',1.0), mode='split').publish('5xx_Error_%_Critical')
      EOF
  custom_email_body = null
  disable_detector  = "true"
}

module "UAT-Zee5-Singleapiplayback-Error-Rate" {
  source           = "./modules/detectors/"
  application_name = "zee5-singleplayback-api-uat"
  metric_label     = "ErrorPercent"
  alert_name       = "Error_Rate_%"
  display_unit     = null
  email_list       = ["Email,mayank.gupta@gssltd.co.in", "Email,mail@gssltd.co.in"]
  warning_description = "Error rate has been greater than 1% for last 2 minutes"
  critical_description = "Error rate has been greater than 2% for last 3 minutes"
  splunk_query     = <<-EOF
          filter_ = filter('sf_environment', 'UAT') and filter('sf_service', 'zee5-singleplayback-api-uat') and filter('sf_dimensionalized', 'true')
          A = data('service.request.count', filter=filter_ and filter('http_status_code', '4*','5*'), rollup='delta').sum(by=['sf_environment', 'sf_service']).publish(label='A', enable=False)
          B = data('service.request.count', filter=filter_ and filter('http_status_code', '*'), rollup='delta').sum(by=['sf_environment', 'sf_service']).publish(label='B', enable=False)
          C = combine(100*((A if A is not None else 0) / B)).publish(label='ErrorPercent')
          detect(when(C > 1,'2m',1.0), mode='split').publish('Error_Rate_%_Warning')
          detect(when(C > 2,'3m',1.0), mode='split').publish('Error_Rate_%_Critical')
      EOF
  custom_email_body = null
}

module "UAT-Zee5-Singleapiplayback-Throughput-Baseline-Warning" {
  source           = "./modules/detectors/"
  application_name = "zee5-singleplayback-api-uat"
  metric_label     = "request_rate"
  alert_name       = "Throughput_Baseline"
  display_unit     = null
  email_list       = ["Email,mayank.gupta@gssltd.co.in", "Email,mail@gssltd.co.in"]
  warning_description = "Throughput for last 10 min is deviating by more than 10 standard deviations as compared to last 4 days data"
  splunk_query     = <<-EOF
          from signalfx.detectors.apm.requests.historical_anomaly_v2 import historical_anomaly
          historical_anomaly.detector_mean_std(clear_num_stddev=2.5, filter_=(filter('sf_environment', 'UAT') and filter('sf_service', 'zee5-singleplayback-api-uat')), fire_num_stddev=10, num_windows=4, orientation='above', resource_type='service', space_between_windows='1d', window_to_compare='10m').publish('Throughput_Baseline_Warning')
      EOF
  static_detector = "false"
  severity        = "Warning"
  custom_email_body = null
}

module "UAT-Zee5-Singleapiplayback-Throughput-Baseline-Critical" {
  source           = "./modules/detectors/"
  application_name = "zee5-singleplayback-api-uat"
  metric_label     = "request_rate"
  alert_name       = "Throughput_Baseline"
  display_unit     = null
  email_list       = ["Email,mayank.gupta@gssltd.co.in", "Email,mail@gssltd.co.in"]
  critical_description = "Throughput for last 5 min is deviating by more than 20 standard deviations as compared to last 4 days data"
  splunk_query     = <<-EOF
          from signalfx.detectors.apm.requests.historical_anomaly_v2 import historical_anomaly
          historical_anomaly.detector_mean_std(clear_num_stddev=19, filter_=(filter('sf_environment', 'UAT') and filter('sf_service', 'zee5-singleplayback-api-uat')), fire_num_stddev=20, num_windows=4, orientation='above', resource_type='service', space_between_windows='1d', window_to_compare='5m').publish('Throughput_Baseline_Critical')
      EOF
  static_detector = "false"
  severity        = "Critical"
  custom_email_body = null
}

module "UAT-Zee5-Singleapiplayback-Throughput-SuddenChange-Warning" {
  source           = "./modules/detectors/"
  application_name = "zee5-singleplayback-api-uat"
  metric_label     = "request_rate"
  alert_name       = "Throughput_SuddenChange"
  display_unit     = null
  email_list       = ["Email,mayank.gupta@gssltd.co.in", "Email,mail@gssltd.co.in"]
  warning_description = "Sudden change (3 SD) in throughput for last 10 min as compared to last 1 hour"
  critical_description = "Sudden change (5 SD) in throughput for last 5 min as compared to last 1 hour"
  splunk_query     = <<-EOF
          from signalfx.detectors.apm.requests.sudden_change_v2 import sudden_change
          sudden_change.detector_mean_std(clear_num_stddev=2.5, current_window='10m', filter_=(filter('sf_environment', 'UAT') and filter('sf_service', 'zee5-singleplayback-api-uat')), fire_num_stddev=3, historical_window='1h', orientation='above', resource_type='service').publish('Throughput_SuddenChange_Warning')
      EOF
  static_detector = "false"
  severity        = "Warning"
  custom_email_body = null
}

module "UAT-Zee5-Singleapiplayback-Throughput-SuddenChange-Critical" {
  source           = "./modules/detectors/"
  application_name = "zee5-singleplayback-api-uat"
  metric_label     = "request_rate"
  alert_name       = "Throughput_SuddenChange"
  display_unit     = null
  email_list       = ["Email,mayank.gupta@gssltd.co.in", "Email,mail@gssltd.co.in"]
  critical_description = "Sudden change (5 SD) in throughput for last 5 min as compared to last 1 hour"
  splunk_query     = <<-EOF
          from signalfx.detectors.apm.requests.sudden_change_v2 import sudden_change
          sudden_change.detector_mean_std(clear_num_stddev=4, current_window='5m', filter_=(filter('sf_environment', 'UAT') and filter('sf_service', 'zee5-singleplayback-api-uat')), fire_num_stddev=5, historical_window='1h', orientation='above', resource_type='service').publish('Throughput_SuddenChange_Critical')
      EOF
  static_detector = "false"
  severity        = "Critical"
  custom_email_body = null
}

module "UAT-Zee5-Singleapiplayback-CPU-Utilization" {
  source           = "./modules/detectors/"
  application_name = "zee5-singleplayback-api-uat"
  metric_label     = "CPU_Utilization"
  alert_name       = "CPU_Utilization_%"
  display_unit     = null
  email_list       = ["Email,mayank.gupta@gssltd.co.in"]
  warning_description = "CPU Utilization(%) has been more than 90% for more than 15 min"
  critical_description = "CPU Utilization(%) has been more than 95% for more than 10 min"
  splunk_query     = <<-EOF
          A = data('container_cpu_utilization', filter=filter('sf_environment', 'UAT') and filter('k8s.deployment.name', 'zee5-singleplayback-api'), rollup='delta').mean(by=['k8s.pod.name', 'k8s.container.name']).scale(0.01).publish(label='CPU_Utilization')
          detect(when(A > 90,'15m',1.0), mode='split').publish('CPU_Utilization_%_Warning')
          detect(when(A > 95,'10m',1.0), mode='split').publish('CPU_Utilization_%_Critical')
      EOF
  custom_email_body = null
}

module "UAT-Zee5-Singleapiplayback-Memory-Utilization" {
  source           = "./modules/detectors/"
  application_name = "zee5-singleplayback-api-uat"
  metric_label     = "Memory_Utilization"
  alert_name       = "Memory_Utilization_%"
  display_unit     = null
  email_list       = ["Email,mayank.gupta@gssltd.co.in"]
  warning_description = "Memory Utilization(%) has been more than 90% for more than 15 min"
  critical_description = "Memory Utilization(%) has been more than 95% for more than 10 min"
  splunk_query     = <<-EOF
          A = data('container.memory.usage', filter=filter('sf_environment', 'UAT') and filter('k8s.deployment.name', 'zee5-singleplayback-api') and filter('container.id', '*')).mean(by=['k8s.pod.name', 'k8s.container.name']).publish(label='A', enable=False)
          B = data('k8s.container.memory_limit', filter=filter('sf_environment', 'UAT') and filter('k8s.deployment.name', 'zee5-singleplayback-api') and filter('container.id', '*')).mean(by=['k8s.pod.name', 'k8s.container.name']).publish(label='B', enable=False)
          C = ((A*100)/B).publish(label='Memory_Utilization')
          detect(when(C > 90,'15m',1.0), mode='split').publish('Memory_Utilization_%_Warning')
          detect(when(C > 95,'10m',1.0), mode='split').publish('Memory_Utilization_%_Critical')
      EOF
  custom_email_body = null
}

module "UAT-Zee5-Singleapiplayback-POD-Restart-count" {
  source           = "./modules/detectors/"
  application_name = "zee5-singleplayback-api-uat"
  metric_label     = "RestartCount"
  alert_name       = "Restart_Count"
  display_unit     = null
  email_list       = ["Email,mayank.gupta@gssltd.co.in"]
  warning_description = "Restart count is more than 3 in last 3 min"
  critical_description = "Restart count is more than 5 in last 2 min"
  splunk_query     = <<-EOF
          A = data('k8s.container.restarts', filter=filter('k8s.deployment.name', 'zee5-singleplayback-api') and filter('sf_environment', 'UAT'), rollup='sum').sum(by=['k8s.deployment.name']).delta().publish(label='RestartCount')
          detect(when(A > 3,'180s',1.0), mode='split').publish('Restart_Count_Warning')
          detect(when(A > 5,'120s',1.0), mode='split').publish('Restart_Count_Critical')
      EOF
  custom_email_body = null
}

module "UAT-Zee5-Singleapiplayback-Running-Pod-Percentage" {
  source           = "./modules/detectors/"
  application_name = "zee5-singleplayback-api-uat"
  metric_label     = "RunningPodPercentage"
  alert_name       = "Running_Pod_%"
  display_unit     = null
  email_list       = ["Email,mayank.gupta@gssltd.co.in"]
  warning_description = "Running pod percentage is below 20 for the last 3 min"
  critical_description = "Running pod percentage is below 10 for the last 2 min"
  splunk_query     = <<-EOF
          A = data('k8s.pod.phase', filter=filter('sf_environment', 'UAT') and filter('sf_service', 'zee5-singleplayback-api-uat') and filter('k8s.deployment.name', 'zee5-singleplayback-api') and filter('k8s.node.name', '*'), rollup='latest').count(by=['k8s.deployment.name']).publish(label='TotalPods', enable=False)
          B = data('k8s.pod.phase', filter=filter('sf_environment', 'UAT') and filter('sf_service', 'zee5-order-uat') and filter('k8s.deployment.name', 'zee5-order') and filter('k8s.node.name', '*'), rollup='latest').between(1.5, 2.5).count(by=['k8s.deployment.name']).publish(label='RunningPods', enable=False)
          C = ((100*B)/A).publish(label='RunningPodPercentage')
          detect(when(C < 20,'180s',1.0), mode='split').publish('Running_Pod_%_Warning')
          detect(when(C < 10,'120s',1.0), mode='split').publish('Running_Pod_%_Critical')
      EOF
  custom_email_body = null
}

module "UAT-Zee5-Singleapiplayback-Throughput-Decreased-Traffic-Warning" {
  source           = "./modules/detectors/"
  application_name = "zee5-singleplayback-api-uat"
  metric_label     = "request_rate"
  alert_name       = "Decreased_Traffic"
  display_unit     = null
  email_list       = ["Email,mayank.gupta@gssltd.co.in"]
  warning_description = "Decreased traffic for last 3 min"
  critical_description = "Decreased traffic for last 2 min"
  splunk_query     = <<-EOF
          from signalfx.detectors.apm.requests.static_v2 import static
          static.detector(clear_lasting=lasting('3m'), clear_threshold=10, filter_=(filter('sf_environment', 'UAT') and filter('sf_service', 'zee5-singleplayback-api-uat')), fire_lasting=lasting('3m'), fire_threshold=5, orientation='below', resource_type='service').publish('Decreased_Traffic_Warning')
      EOF
  static_detector = "false"
  severity        = "Warning"
  custom_email_body = null
}

module "UAT-Zee5-Singleapiplayback-Throughput-Decreased-Traffic-Critical" {
  source           = "./modules/detectors/"
  application_name = "zee5-singleplayback-api-uat"
  metric_label     = "request_rate"
  alert_name       = "Decreased_Traffic"
  display_unit     = null
  email_list       = ["Email,mayank.gupta@gssltd.co.in"]
  warning_description = "Decreased traffic for last 3 min"
  critical_description = "Decreased traffic for last 2 min"
  splunk_query     = <<-EOF
          from signalfx.detectors.apm.requests.static_v2 import static
          static.detector(clear_lasting=lasting('3m'), clear_threshold=2, filter_=(filter('sf_environment', 'UAT') and filter('sf_service', 'zee5-singleplayback-api-uat')), fire_lasting=lasting('2m'), fire_threshold=1, orientation='below', resource_type='service').publish('Decreased_Traffic_Critical')
      EOF
  static_detector = "false"
  severity        = "Critical"
  custom_email_body = null
}