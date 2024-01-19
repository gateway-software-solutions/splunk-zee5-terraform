module "Synthetic-Monitoring-Count-Alert-communication-engine" {
  source                = "./modules/syntheticDetector/"
  alert_name            = "Synthetics"
  synthetic_test_name   = "communication-engine"
  severity              = "Critical"
  email_list            = ["Email,mayank.gupta@gssltd.co.in"]
}