terraform {
  required_providers {
    signalfx = {
      source = "splunk-terraform/signalfx"
      version = ">=9.0.0"
    }
  }
}

variable "synthetic_test_name" {}
variable "synthetic_test_type" {default = "http"}
variable "metric_label" {default = "success_count"}
variable "display_unit" {default = null}
variable "alert_name" {default = "Synthetics"}
variable "severity" { default = "Warning"}
variable "alert_description" {default ="The configured synthetic test has failed for more than 3 times in a row"}


variable "critical" { default=2.0 }
variable "duration" { default=300 } 
variable "warning" { default=1.0 }
variable "warning_duration" { default=200 }
variable "critical_duration" { default=200 }

variable "threshold_operator" { default=">" }
variable "threshold_occurrences" { default="all" }
variable "signal_lost" { default="900" }
variable "signal_lost_open_new_alert" { default=false }
variable "runbook" { default=" " }
variable "email_list" { type = list}
variable "static_detector" {default = "true"}


variable "warning_description" {default ="Warning threshold has been breached."}
variable "critical_description" {default ="Critical threshold has been breached."}

variable "disable_detector" {default = "false"}

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

resource "signalfx_detector" "detector_zee_synthetic_static" {
  name        = "${var.alert_name}-${var.synthetic_test_name}"
  description = "Detector created using terraform for synthetic test ${var.synthetic_test_name}"
  max_delay   = 30
  timezone    = "Asia/Kolkata"

  program_text = <<-EOF
          A = data('synthetics.run.count', filter=filter('test', '${var.synthetic_test_name}') and filter('success','true'), extrapolation='zero').publish(label='${var.metric_label}')
          detect(when(A < 1,'4m', 1.0), mode='split').publish('${var.alert_name}_${var.severity}')
      EOF

  rule {
    description   = "${var.alert_description}"
    severity      = "${var.severity}"
    detect_label  = "${var.alert_name}_${var.severity}"
    notifications = var.email_list
    parameterized_body = var.custom_email_body
    parameterized_subject = var.custom_email_subject
    runbook_url   = var.custom_runbook_url
    tip           = var.custom_tip_message
    disabled      = var.disable_detector
  }
  viz_options {
  	label      = var.metric_label
  	value_unit = var.display_unit
  }
}
