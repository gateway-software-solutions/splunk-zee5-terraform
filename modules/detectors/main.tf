terraform {
  required_providers {
    signalfx = {
      source = "splunk-terraform/signalfx"
      version = ">=9.0.0"
    }
  }
}

variable "application_name" {default = "zee5-singleplayback-api-uat"}
variable "metric_label" {default = "monitored_metric"}
variable "display_unit" {}
variable "critical" { default=2.0 }
variable "duration" { default=300 } 
variable "warning" { default=1.0 }
variable "warning_duration" { default=200 }
variable "critical_duration" { default=200 }
variable "alert_name" {default = "P90 Latency"}
variable "splunk_query" {}
variable "threshold_operator" { default=">" }
variable "threshold_occurrences" { default="all" }
variable "signal_lost" { default="900" }
variable "signal_lost_open_new_alert" { default=false }
variable "runbook" { default=" " }
variable "email_list" { type = list}
variable "static_detector" {default = "true"}
variable "severity" { default = "Warning"}

variable "warning_description" {default ="Warning threshold has been breached."}
variable "critical_description" {default ="Critical threshold has been breached."}

variable "custom_email_body" {
	default = <<-EOF
		{{#if anomalous}}
			Rule "{{{ruleName}}}" in detector "{{{detectorName}}}" triggered at {{timestamp}}.
		{{else}}
			Rule "{{{ruleName}}}" in detector "{{{detectorName}}}" cleared at {{timestamp}}.
		{{/if}}

		{{#if anomalous}}
		Triggering condition: {{{readableRule}}}
		{{/if}}

		{{#if anomalous}}Signal value for spans.count: {{inputs.A.value}}
		{{else}}Current signal value for spans.count: {{inputs.A.value}}
		{{/if}}

		{{#notEmpty dimensions}}
		Signal details:
		{{{dimensions}}}
		{{/notEmpty}}

		{{#if anomalous}}
		{{#if runbookUrl}}Runbook: {{{runbookUrl}}}{{/if}}
		{{#if tip}}Tip: {{{tip}}}{{/if}}
		{{/if}}
	EOF
}

variable "custom_email_subject" {
	default = "{{ruleSeverity}} Alert: {{{detectorName}}}"
}

variable "custom_runbook_url" {
	default = "https://runbookurl.to.be.provided"
}

variable "custom_tip_message" {
	default = "any message to be shown as tip or helping text"
}

resource "signalfx_detector" "detector_zee_custom_static" {
  count       = var.static_detector ? 1 : 0
  name        = "${var.alert_name}-${var.application_name}"
  description = "Detector created using terraform for service ${var.application_name}"
  max_delay   = 30
  timezone    = "Asia/Kolkata"

  program_text = var.splunk_query

  rule {
    description   = "${var.warning_description}"
    severity      = "Warning"
    detect_label  = "${var.alert_name}_Warning"
    notifications = var.email_list
    parameterized_body = var.custom_email_body
    parameterized_subject = var.custom_email_subject
    runbook_url   = var.custom_runbook_url
    tip           = var.custom_tip_message
  }
  rule {
    description   = "${var.critical_description}"
    severity      = "Critical"
    detect_label  = "${var.alert_name}_Critical"
    notifications = var.email_list
    parameterized_body = var.custom_email_body
    parameterized_subject = var.custom_email_subject
    runbook_url   = var.custom_runbook_url
    tip           = var.custom_tip_message
  }

  viz_options {
  	label      = var.metric_label
  	value_unit = var.display_unit
  }
}

resource "signalfx_detector" "detector_zee_custom_dynamic" {
  count       = var.static_detector ? 0 : 1
  name        = "${var.alert_name}-${var.application_name}-${var.severity}"
  description = "Detector created using terraform for service ${var.application_name}"
  max_delay   = 30
  timezone    = "Asia/Kolkata"

  program_text = var.splunk_query

  rule {
    description   = var.severity == "Warning" ? "${var.warning_description}" : "${var.critical_description}"
    severity      = "${var.severity}"
    detect_label  = "${var.alert_name}_${var.severity}"
    notifications = var.email_list
    parameterized_body = var.custom_email_body
    parameterized_subject = var.custom_email_subject
    runbook_url   = var.custom_runbook_url
    tip           = var.custom_tip_message
 }
}