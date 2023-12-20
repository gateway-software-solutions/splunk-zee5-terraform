module "MongoDB_DatabaseCount" {
  source           = "./modules/lbDetectors/"
  application_name = "MongoDB"
  metric_label     = "DatabaseCount"
  alert_name       = "MongoDBCount"
  display_unit     = null
  email_list       = ["Email,mayank.gupta@gssltd.co.in"]
  critical_description = "The number of active mongo databases is less than 10 for last 5 min"
  splunk_query     = <<-EOF
          A = data('mongodb_up', filter=filter('sf_environment', 'PROD'), extrapolation='zero').count().publish(label='DatabaseCount')
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
  critical_description = "The mongo db cluster is down for last 5 min"
  splunk_query     = <<-EOF
          A = data('mongodb_up', filter=filter('sf_environment', 'PROD'), extrapolation='zero').publish(label='DatabaseStatus')
          detect(when(A < 1,'5m',1.0), mode='split').publish('MongoDBStatus_Critical')
      EOF
  custom_email_body = null
  critical_detector = "true"
  delay_in_sec = 450
}