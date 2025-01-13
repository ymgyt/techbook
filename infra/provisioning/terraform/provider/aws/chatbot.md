# Chatbot

```hcl
resource "aws_chatbot_slack_channel_configuration" "ymgyt" {
  configuration_name = "ymgyt"

  slack_channel_id = local.slack.channel_id
  slack_team_id    = local.slack.workspace_id

  iam_role_arn = aws_iam_role.chatbot.arn
  guardrail_policy_arns = [
    "arn:aws:iam::aws:policy/AWSResourceExplorerReadOnlyAccess"
  ]

  logging_level = "INFO"

  user_authorization_required = null

  sns_topic_arns = var.sns_topic_arns
}

resource "aws_iam_role" "chatbot" {
  name               = "chatbot"
  assume_role_policy = data.aws_iam_policy_document.chatbot.json
}

data "aws_iam_policy_document" "chatbot" {
  statement {
    sid     = "ChatbotAssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["chatbot.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "chatbot" {
  role       = aws_iam_role.chatbot.name
  policy_arn = "arn:aws:iam::aws:policy/AWSResourceExplorerReadOnlyAccess"
}
```
