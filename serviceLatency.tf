module "UAT-Zee5-Singleapiplayback-P90-Latency" {
  source                = "./modules/latencyDetector/"
  application_name      = "zee5-singleplayback-api-uat"
  environment           = "UAT"
  metric_label          = "p90Latency"
  latency_to_alert      = "p90"
  alert_name            = "P90_Service_Latency"
  warning               = 450 #Response-Time-warning-milliseconds
  warning_duration      = "4m" #Response-Time-warning_duration
  critical              = 650 #Avg-Response-Time-critical-milliseconds
  critical_duration     = "3m" #Response-Time-duration
  display_unit          = "Millisecond"
  warning_description   = "P90 Service latency > 450 ms for the last 4 minutes"
  critical_description  = "P90 Service latency > 650 ms for the last 3 minutes" 
  threshold_occurrences = 1.0
  email_list            = ["Email,mayank.gupta@gssltd.co.in"]
  custom_email_body     = <<-EOF
      {{#if anomalous}}
        Rule "{{{ruleName}}}" in detector "{{{detectorName}}}" triggered at {{timestamp}}.
      {{else}}
        Rule "{{{ruleName}}}" in detector "{{{detectorName}}}" cleared at {{timestamp}}.
      {{/if}}

      {{#if anomalous}}
      Triggering condition: {{{readableRule}}}
      {{/if}}

      {{#if anomalous}}Signal value for p90 latency (ms): {{inputs.latency.value}}
      {{else}}Current signal value for p90 latency (ms): {{inputs.latency.value}}
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

module "UAT-Zee5-Singleapiplayback-Max-Latency" {
  source                = "./modules/latencyDetector/"
  application_name      = "zee5-singleplayback-api-uat"
  environment           = "UAT"
  metric_label          = "maxLatency"
  latency_to_alert      = "max"
  alert_name            = "Max_Service_Latency"
  warning               = 800 #Response-Time-warning-milliseconds
  warning_duration      = "4m" #Response-Time-warning_duration
  critical              = 900 #Avg-Response-Time-critical-milliseconds
  critical_duration     = "3m" #Response-Time-duration
  display_unit          = "Millisecond"
  threshold_occurrences = 1.0
  warning_description   = "Max Service latency > 800 ms for the last 4 minutes"
  critical_description  = "Max Service latency > 900 ms for the last 3 minutes" 
  email_list            = ["Email,mayank.gupta@gssltd.co.in"]
  custom_email_body     = <<-EOF
      {{#if anomalous}}
        Rule "{{{ruleName}}}" in detector "{{{detectorName}}}" triggered at {{timestamp}}.
      {{else}}
        Rule "{{{ruleName}}}" in detector "{{{detectorName}}}" cleared at {{timestamp}}.
      {{/if}}

      {{#if anomalous}}
      Triggering condition: {{{readableRule}}}
      {{/if}}

      {{#if anomalous}}Signal value for max latency (ms): {{inputs.latency.value}}
      {{else}}Current signal value for max latency (ms): {{inputs.latency.value}}
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