# EventBridge

## Default Bus

lambdaを呼び出すruleを追加

```hcl
# --------------
# target lambda
# --------------
data "aws_lambda_function" "target" {
  function_name = "target"
}

# ----------------
# default bus rule
# ----------------
resource "aws_cloudwatch_event_rule" "example" {
  name           = "example"
  description    = "..."
  event_bus_name = "default"
  event_pattern = jsonencode({
    source = ["aws.foo"]
  })
}

resource "aws_cloudwatch_event_target" "invoke_lambda_example" {
  rule           = aws_cloudwatch_event_rule.example.name
  event_bus_name = "default"
  arn            = data.aws_lambda_function.example.arn
}

# Grant event rule to invoke lambda
resource "aws_lambda_permission" "allow_event_rule_invoke_example" {
  action              = "lambda:InvokeFunction"
  function_name       = data.aws_lambda_function.example.function_name
  principal           = "events.amazonaws.com"
  source_arn          = aws_cloudwatch_event_rule.example.arn
  statement_id_prefix = "allow-event-rule-invoke-example"
}
```

## Custom Bus

ruleとtargetはdefaultと同じ

```hcl
resource "aws_cloudwatch_event_bus" "custom" {
  name        = "custom"
  description = "..."
}
```

## Cross Region

他regionからcross regionでevent busにforwardする

```hcl
# -------------
# Other Regions
# -------------
locals {
  main_region = "ap-northeast-1"

  foo_regions = [
    "ap-northeast-1",
    "us-east-1",
    "us-west-1",
  ]

  target_regions = toset(setsubtract(distinct(concat(local.foo_regions)), [local.main_region]))
}

resource "aws_cloudwatch_event_rule" "example_cross_region" {
  for_each = local.target_regions

  region         = each.key
  name           = "forward"
  description    = "..."
  event_bus_name = "default"
  event_pattern = jsonencode({
    source = ["aws.foo"]
  })
}

resource "aws_cloudwatch_event_target" "example_event_bus" {
  for_each = aws_cloudwatch_event_rule.example_cross_region

  region   = each.key
  rule     = each.value.name
  arn      = aws_cloudwatch_event_bus.example.arn
  role_arn = aws_iam_role.event_bridge_example_cross_region.arn
}

# event_ruleがcross regionでeventをforwardするためのrole
resource "aws_iam_role" "event_bridge_example" {
  name = "EventBridgeExampleCrossRegion"
  assume_role_policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Principal : {
          Service : "events.amazonaws.com"
        },
        Action : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "allow_event_rule_forward_events" {
  role = aws_iam_role.event_bridge_example_cross_region.id
  name = "allow-event-rule-forward-events"
  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Action : [
          "events:PutEvents"
        ],
        Resource : [
          aws_cloudwatch_event_bus.example.arn
        ]
      }
    ]
  })
}
```
