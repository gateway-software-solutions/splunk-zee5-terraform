module "Kafka_Server_Consumer_Lag_Offsets" {
  source           = "./modules/lbDetectors/"
  application_name = "confluent-kafka-topic"
  metric_label     = "Offsets"
  alert_name       = "ConfluentKafkaServerConsumerLagOffset"
  display_unit     = null
  email_list       = ["Email,mayank.gupta@gssltd.co.in"]
  critical_description = "The offset for the topic is more than 100 for last 5 min"
  splunk_query     = <<-EOF
          A = data('confluent_kafka_server_consumer_lag_offsets', filter=filter('topic', 'cmd.order.turbine', 'evt.billingretry', 'cmd.zee.scheduler', 'cmd.turbine.order', 'cmd.turbine.renewal', 'cmd.turbine.olm.s2s', 'evt.predebitnotification', 'cmd.aurora.payment', 'evt.plan', 'evt.planentitlement', 'evt_cms_content_partner', 'evt.subscription', 'cmd.aurora.order', 'cmd.renewal.order', 'evt.ordertaxation', 'evt.ordertaxationrefund', 'cmd.order.renewal', 'cmd.order.subscription', 'evt.ordercompleted', 'cmd.subscription.order', 'cmd.subscription.renewal', 'cmd.subscription.referral', 'evt.packattachretry', 'cmd.b2b.subscription', 'tvod_first_play') and filter('sf_environment','PROD'), rollup='latest').sum(by=['topic']).publish(label='Offsets')
          detect(when(A > 100,'5m',1.0), mode='split').publish('ConfluentKafkaServerConsumerLagOffset_Critical')
      EOF
  custom_email_body = null
  critical_detector = "true"
  delay_in_sec = 450
}

module "Kafka_Consumer_Group_Lag" {
  source           = "./modules/lbDetectors/"
  application_name = "confluent-kafka-topic"
  metric_label     = "GroupLag"
  alert_name       = "ConfluentKafkaConsumerGroupLag"
  display_unit     = null
  email_list       = ["Email,mayank.gupta@gssltd.co.in"]
  critical_description = "The lag for the topic is more than 100 for last 5 min"
  splunk_query     = <<-EOF
          A = data('kafka.consumer_group.lag', filter=filter('topic', 'cmd.order.turbine', 'evt.billingretry', 'cmd.zee.scheduler', 'cmd.turbine.order', 'cmd.turbine.renewal', 'cmd.turbine.olm.s2s', 'evt.predebitnotification', 'cmd.aurora.payment', 'evt.plan', 'evt.planentitlement', 'evt_cms_content_partner', 'evt.subscription', 'cmd.aurora.order', 'cmd.renewal.order', 'evt.ordertaxation', 'evt.ordertaxationrefund', 'cmd.order.renewal', 'cmd.order.subscription', 'evt.ordercompleted', 'cmd.subscription.order', 'cmd.subscription.renewal', 'cmd.subscription.referral', 'evt.packattachretry', 'cmd.b2b.subscription', 'tvod_first_play') and filter('sf_environment', 'PROD'), rollup='latest').sum(by=['topic']).publish(label='GroupLag')
          detect(when(A > 100,'5m',1.0), mode='split').publish('ConfluentKafkaConsumerGroupLag_Critical')
      EOF
  custom_email_body = null
  critical_detector = "true"
  delay_in_sec = 450
}
