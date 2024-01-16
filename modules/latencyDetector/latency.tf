## name of the apm service
variable "application_name" {default = "zee5-singleplayback-api-uat"}

## label displayed on graph
variable "metric_label" {default = "monitored_metric"}

## custom display unit to be set
variable "display_unit" {}

## threshold for critical alert. value to be provided in nanoseconds. setting default value of 600 ms
variable "critical" { default=600000000 }

## duration for which threshold shall breach before alerting. Specify time with unit. default of 2 minutes
variable "critical_duration" { default="2m" }

## threshold for warning alert. value to be provided in nanoseconds. setting default value of 400 ms
variable "warning" { default=400000000 }

## duration for which threshold shall breach before alerting. Specify time with unit. default of 3 minutes
variable "warning_duration" { default="3m" }

## latency metric to alert on (median,p90,p99,min,max)
variable "latency_to_alert" { default="p90"}

## name of environment
variable "environment" { default="UAT"}

variable "alert_name" {default = "P90_Latency"}

## variable "condition_state" { default=true }
variable "threshold_operator" { default=">" }

## percentage of time for which the threshold is breached
variable "threshold_occurrences" { default=1.0 }

## variable "signal_lost" { default="900" }
## variable "signal_lost_open_new_alert" { default=false }
## variable "runbook" { default=" " }

## list of emails to be alerted
variable "email_list" { type = list}

## alert description messages
variable warning_description {default="Warning threshold has been breached."}
variable critical_description {default="Critical threshold has been breached."}

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

variable "disable_detector" {default = "false"}

resource "signalfx_detector" "detector_zee_custom" {
  name        = "${var.alert_name}-${var.application_name}"
  description = "Detector created using terraform for service ${var.application_name}"
  max_delay   = 30

  program_text = <<-EOF
          def weighted_duration(base, p, filter_, groupby):
            error_durations     = data(base + '.duration.ns.' + p, filter=filter_ and filter('sf_error', 'true'),  rollup='max').mean(by=groupby, allow_missing=['sf_httpMethod'])
            non_error_durations = data(base + '.duration.ns.' + p, filter=filter_ and filter('sf_error', 'false'), rollup='max').mean(by=groupby, allow_missing=['sf_httpMethod'])

            error_counts     = data(base + '.count', filter=filter_ and filter('sf_error', 'true'),  rollup='sum').sum(by=groupby, allow_missing=['sf_httpMethod'])
            non_error_counts = data(base + '.count', filter=filter_ and filter('sf_error', 'false'), rollup='sum').sum(by=groupby, allow_missing=['sf_httpMethod'])

            error_weight     = (error_durations * error_counts).sum(over='1m')
            non_error_weight = (non_error_durations * non_error_counts).sum(over='1m')

            total_weight = combine((error_weight if error_weight is not None else 0) + (non_error_weight if non_error_weight is not None else 0))
            total = combine((error_counts if error_counts is not None else 0) + (non_error_counts if non_error_counts is not None else 0)).sum(over='1m')
            return (total_weight / total)

          filter_ = filter('sf_environment', '${var.environment}') and filter('sf_service', '${var.application_name}') and not filter('sf_dimensionalized', '*')
          groupby = ['sf_service', 'sf_environment']
          latency = weighted_duration('service.request', '${var.latency_to_alert}', filter_, groupby).scale(0.000001).publish(label='${var.metric_label}')
          detect(when(latency ${var.threshold_operator} ${var.warning},'${var.warning_duration}', ${var.threshold_occurrences}), mode='split').publish('${var.alert_name}_Warning')
          detect(when(latency ${var.threshold_operator} ${var.critical},'${var.critical_duration}', ${var.threshold_occurrences}), mode='split').publish('${var.alert_name}_Critical')
      EOF

  rule {
    description   = "${var.warning_description}"
    severity      = "Warning"
    detect_label  = "${var.alert_name}_Warning"
    notifications = var.email_list
    parameterized_body = var.custom_email_body
    parameterized_subject = var.custom_email_subject
    runbook_url   = var.custom_runbook_url
    tip           = var.custom_tip_message
    disabled      = var.disable_detector
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
    disabled      = var.disable_detector
  }

  viz_options {
  	label      = var.metric_label
  	value_unit = var.display_unit
  }
}