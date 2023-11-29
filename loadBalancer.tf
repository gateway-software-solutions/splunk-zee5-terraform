module "ApiGee_ProxyV2_Latency_P95_ProxyName_GWAPI" {
  source           = "./modules/lbDetectors/"
  application_name = "gwapi"
  metric_label     = "p95Latency"
  alert_name       = "ProxyP95Latency"
  display_unit     = "Millisecond"
  email_list       = ["Email,mayank.gupta@gssltd.co.in"]
  critical_description = "p95 latency is greater than 300ms for last 3 minutes"
  splunk_query     = <<-EOF
          A = data('proxyv2/latencies_percentile', filter=filter('proxy_name', 'gwapi') and filter('percentile', 'p95')).mean(by=['proxy_name']).publish(label='p95Latency')
          detect(when(A > 300,'3m',1.0), mode='split').publish('ProxyP95Latency_Critical')
      EOF
  custom_email_body = null
  critical_detector = "true"
}

module "ApiGee_ProxyV2_ErrorRate_ProxyName_GWAPI" {
  source           = "./modules/lbDetectors/"
  application_name = "gwapi"
  metric_label     = "errorRate"
  alert_name       = "ProxyErrorRate"
  display_unit     = null
  email_list       = ["Email,mayank.gupta@gssltd.co.in"]
  critical_description = "Error rate is more then 20% for last 3 minutes"
  splunk_query     = <<-EOF
          B = data('proxyv2/response_count', filter=filter('proxy_name', 'gwapi') and filter('env', '*') and filter('response_code', '4*', '5*')).sum(by=['proxy_name']).publish(label='B', enable=False)
          C = data('proxyv2/response_count', filter=filter('proxy_name', 'gwapi') and filter('env', '*') and filter('response_code', '*')).sum(by=['proxy_name']).publish(label='C', enable=False)
          D = combine((100*(B if B is not None else 0)/C)).publish(label='errorRate')
          detect(when(D > 20,'3m',1.0), mode='split').publish('ProxyErrorRate_Critical')
      EOF
  custom_email_body = null
  critical_detector = "true"
}

module "ApiGee_ProxyV2_5xxPercentage_ProxyName_GWAPI" {
  source           = "./modules/lbDetectors/"
  application_name = "gwapi"
  metric_label     = "5xxPercent"
  alert_name       = "Proxy5xxPercentage"
  display_unit     = null
  email_list       = ["Email,mayank.gupta@gssltd.co.in"]
  critical_description = "5xx percent is more then 20% for last 3 minutes"
  splunk_query     = <<-EOF
          B = data('proxyv2/response_count', filter=filter('proxy_name', 'gwapi') and filter('env', '*') and filter('response_code', '5*')).sum(by=['proxy_name']).publish(label='B', enable=False)
          C = data('proxyv2/response_count', filter=filter('proxy_name', 'gwapi') and filter('env', '*') and filter('response_code', '*')).sum(by=['proxy_name']).publish(label='C', enable=False)
          E = combine((((B if B is not None else 0)*100)/C)).publish(label='5xxPercent')
          detect(when(E > 20,'3m',1.0), mode='split').publish('Proxy5xxPercentage_Critical')
      EOF
  custom_email_body = null
  critical_detector = "true"
}

module "ApiGee_TargetV2_Latency_P95_ProxyName_GWAPI" {
  source           = "./modules/lbDetectors/"
  application_name = "gwapi"
  metric_label     = "p95Latency"
  alert_name       = "TargetP95Latency"
  display_unit     = "Millisecond"
  email_list       = ["Email,mayank.gupta@gssltd.co.in"]
  critical_description = "p95 latency is greater than 300ms for last 3 minutes"
  splunk_query     = <<-EOF
          A = data('targetv2/latencies_percentile', filter=filter('percentile', 'p95') and filter('env', '*') and filter('proxy_name', 'gwapi')).mean(by=['proxy_name']).publish(label='p95Latency')
          detect(when(A > 300,'3m',1.0), mode='split').publish('TargetP95Latency_Critical')
      EOF
  custom_email_body = null
  critical_detector = "true"
}

module "ApiGee_TargetV2_EndPointLatency_P95_ProxyName_GWAPI_Recommendation-api" {
  source           = "./modules/lbDetectors/"
  application_name = "gwapi_recommendation-api.primary-uat"
  metric_label     = "p95Latency"
  alert_name       = "TargetEndpointP95Latency"
  display_unit     = "Millisecond"
  email_list       = ["Email,mayank.gupta@gssltd.co.in"]
  critical_description = "p95 latency is greater than 300ms for last 3 minutes"
  splunk_query     = <<-EOF
          A = data('targetv2/latencies_percentile', filter=filter('percentile', 'p95') and filter('env', '*') and filter('proxy_name', 'gwapi') and filter('endpoint','recommendation-api.primary-uat.as1.nonprod.zee5.internal')).mean(by=['endpoint']).publish(label='p95Latency')
          detect(when(A > 300,'3m',1.0), mode='split').publish('TargetEndpointP95Latency_Critical')
      EOF
  custom_email_body = null
  critical_detector = "true"
}

module "GLB_TotalLatency_TargetProxyName_apigee-https-https-proxy" {
  source           = "./modules/lbDetectors/"
  application_name = "gclb-zee5-uat-apigee-https-https-proxy"
  metric_label     = "totalLatency"
  alert_name       = "GLBTotalLatency"
  display_unit     = "Millisecond"
  email_list       = ["Email,mayank.gupta@gssltd.co.in"]
  critical_description = "Total latency for target proxy is greater than 300ms for last 3 minutes"
  splunk_query     = <<-EOF
          A = data('https/backend_latencies', filter=filter('backend_target_name', '*') and filter('forwarding_rule_name', '*') and filter('target_proxy_name', 'gclb-zee5-uat-apigee-https-https-proxy') and filter('response_code', '*') and filter('service', 'loadbalancing'), rollup='average').mean(by=['target_proxy_name']).publish(label='totalLatency')
          detect(when(A > 300,'3m',1.0), mode='split').publish('GLBTotalLatency_Critical')
      EOF
  custom_email_body = null
  critical_detector = "true"
}

module "ISTIO_5xxPercentage_DestinationService_recommendation-api-service" {
  source           = "./modules/lbDetectors/"
  application_name = "istio_recommendation-api-service"
  metric_label     = "5xxPercent"
  alert_name       = "Istio5xxPercentage"
  display_unit_suffix = "%"
  email_list       = ["Email,mayank.gupta@gssltd.co.in"]
  critical_description = "5xx percent is more then 20% for last 3 minutes"
  splunk_query     = <<-EOF
          B = data('istio_requests_total', filter=filter('destination_service_name', 'recommendation-api-service') and filter('response_code', '*'), rollup='delta').sum(by=['destination_service_name']).publish(label='B')
          A = data('istio_requests_total', filter=filter('destination_service_name', 'recommendation-api-service') and filter('response_code', '5*'), rollup='delta').sum(by=['destination_service_name']).publish(label='A')
          C = combine((((A if A is not None else 0)*100)/B)).publish(label='5xxPercent')
          detect(when(C > 20,'3m',1.0), mode='split').publish('Istio5xxPercentage_Critical')
      EOF
  custom_email_body = null
  critical_detector = "true"
}

module "ISTIO_TPS_DestinationService_recommendation-api-service" {
  source           = "./modules/lbDetectors/"
  application_name = "istio_recommendation-api-service"
  metric_label     = "tps"
  alert_name       = "IstioTPS"
  display_unit_suffix = "%"
  email_list       = ["Email,mayank.gupta@gssltd.co.in"]
  critical_description = "No request received in last 10 min"
  splunk_query     = <<-EOF
          A = data('istio_requests_total', filter=filter('destination_service_name', 'recommendation-api-service'), rollup='delta').sum(by=['destination_service_name']).sum(over='10m').publish(label='A')
          B = combine(A if A is not None else 0)
          detect(when(B == 0), mode='split').publish('IstioTPS_Critical')
      EOF
  custom_email_body = null
  critical_detector = "true"
}

module "ISTIO_MeanLatency_DestinationService_recommendation-api-service" {
  source           = "./modules/lbDetectors/"
  application_name = "istio_recommendation-api-service"
  metric_label     = "meanLatency"
  alert_name       = "IstioMeanLatency"
  display_unit     = "Millisecond"
  email_list       = ["Email,mayank.gupta@gssltd.co.in"]
  critical_description = "Mean latency for service is greater than 300ms for last 3 minutes"
  splunk_query     = <<-EOF
          A = data('istio_request_duration_milliseconds_count', filter=filter('destination_service_name', 'recommendation-api-service') and filter('response_code', '*')).sum(by=['destination_service_name']).publish(label='A', enable=False)
          B = data('istio_request_duration_milliseconds_sum', filter=filter('destination_service_name', 'recommendation-api-service') and filter('response_code', '*')).sum(by=['destination_service_name']).publish(label='B', enable=False)
          C = combine((B if B is not None else 0)/(A if A is not None else 1)).mean(by=['destination_service_name']).publish(label='meanLatency')
          detect(when(A > 300,'3m',1.0), mode='split').publish('IstioMeanLatency_Critical')
      EOF
  custom_email_body = null
  critical_detector = "true"
}
