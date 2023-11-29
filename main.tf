terraform {
  required_providers {
    signalfx = {
      source = "splunk-terraform/signalfx"
      version = ">=9.0.0"
    }
  }
}

provider "signalfx" {
  auth_token = "wHe6dTnXoreH7ZYyJUreiA"
  # If your organization uses a different realm
  api_url = "https://api.jp0.signalfx.com"
  # If your organization uses a custom URL
  # custom_app_url = "https://myorg.signalfx.com"
}