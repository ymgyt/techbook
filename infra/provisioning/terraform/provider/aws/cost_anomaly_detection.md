# Cost Anomaly Detection

## Monitor

```hcl
# サービス全体
resource "aws_ce_anomaly_monitor" "aws_service" {
  monitor_dimension = "SERVICE"
  monitor_type      = "DIMENSIONAL"
  name              = "aws-service-monitor"
}

# Linked account
resource "aws_ce_anomaly_monitor" "account" {
  monitor_dimension = null
  monitor_specification = jsonencode({
    # 明示的な null 指定がないとplanで差分がでる
    And            = null
    CostCategories = null
    Dimensions = {
      Key          = "LINKED_ACCOUNT"
      MatchOptions = null
      Values       = ["111222333"]
    }
    Not  = null
    Or   = null
    Tags = null
  })
  monitor_type = "CUSTOM"
  name         = "account"
  tags         = {}
  tags_all     = {}
}
```

* `Dimensions`: cost explorerのAPI上のmodel

## Subscription

### Email
```hcl
resource "aws_ce_anomaly_subscription" "email" {
  name      = "weekly"
  frequency = "WEEKLY" # DAILY | WEEKLY | IMMEDIATE

  monitor_arn_list = [
    aws_ce_anomaly_monitor.aws_service.arn
  ]

  subscriber {
    type    = "EMAIL" # EMAIL | SNS
    address = local.subscription_email
  }

  # https://docs.aws.amazon.com/aws-cost-management/latest/APIReference/API_AnomalySubscription.html
  threshold_expression {
    # これで dimension OR dimension を表現している
    or {
      dimension {
        key           = "ANOMALY_TOTAL_IMPACT_PERCENTAGE"
        match_options = ["GREATER_THAN_OR_EQUAL"]
        values        = ["30"]
      }
    }
    or {
      dimension {
        key           = "ANOMALY_TOTAL_IMPACT_ABSOLUTE"
        match_options = ["GREATER_THAN_OR_EQUAL"]
        values        = ["100"]
      }
    }
  }
}
```

* 変だけど、`or { dimension } or { dimension }` と書く
  * `dimension or { dimension }` と書くとエラーになる
  * `or { dimension dimension }` もエラー

### SNS

```hcl
resource "aws_ce_anomaly_subscription" "immediate" {
  name      = "immediate"
  frequency = "IMMEDIATE" # DAILY | WEEKLY | IMMEDIATE

  monitor_arn_list = [
    aws_ce_anomaly_monitor.account.arn
  ]

  subscriber {
    type    = "SNS" # EMAIL | SNS
    address = aws_sns_topic.cost_anomaly.arn
  }

  threshold_expression {
    dimension {
      key           = "ANOMALY_TOTAL_IMPACT_ABSOLUTE"
      match_options = ["GREATER_THAN_OR_EQUAL"]
      values        = ["20"]
    }
  }
}

resource "aws_sns_topic" "cost_anomaly" {
  name = "cost_anomaly"
}

data "aws_iam_policy_document" "sns_cost_anomaly" {
  statement {
    sid       = "AnomalyDetectionPublishSNSTopics"
    effect    = "Allow"
    resources = [aws_sns_topic.cost_anomaly.arn]
    actions   = ["sns:Publish"]

    principals {
      type = "Service"
      identifiers = [
        "costalerts.amazonaws.com",
      ]
    }
  }
}

resource "aws_sns_topic_policy" "sns_cost_anomaly" {
  arn    = aws_sns_topic.cost_anomaly.arn
  policy = data.aws_iam_policy_document.sns_cost_anomaly.json
}
```
