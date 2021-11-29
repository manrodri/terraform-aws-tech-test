resource "aws_iam_role" "iam_for_lambda_main" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda_basic" {
  name        = "lambda-basic-execution-policy-main"
  description = "A test policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
{
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }

  ]
}
EOF
}


resource "aws_iam_policy" "policy" {
  name        = "test-policy-main"
  description = "A test policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:*",
        "dynamodb:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "test-attach-2" {
  role       = aws_iam_role.iam_for_lambda_main.name
  policy_arn = aws_iam_policy.lambda_basic.arn
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.iam_for_lambda_main.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_lambda_function" "main_lambda" {
  filename      = var.filename
  function_name = var.lambda_function_name
  role          = aws_iam_role.iam_for_lambda_main.arn
  handler       = var.lambda_handler
  runtime       = "python3.8"


  source_code_hash = filebase64sha256("templates/main.zip")


  environment {
    variables = {
      TABLE_NAME  = aws_dynamodb_table.basic-dynamodb-table.name
      LABEL_KEY   = "Owner"
      LABEL_VALUE = local.common_tags.Owner
    }
  }
}


resource "aws_lambda_function" "delete_lambda" {
  filename = var.filename_delete
  function_name = var.lambda_function_name_delete
  role = aws_iam_role.iam_for_lambda_main.arn
  handler = var.lambda_handler_delete
  runtime = "python3.8"


  source_code_hash = filebase64sha256("templates/delete_items.zip")


  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.basic-dynamodb-table.name
      LABEL_KEY = "Owner"
      LABEL_VALUE = local.common_tags.Owner
    }
  }
}

resource "aws_cloudwatch_event_rule" "every_hour" {
  name                = "every-one-hour"
  schedule_expression = "rate(1 hour)"
}

resource "aws_cloudwatch_event_rule" "every_day" {
  name                = "every-one-day"
  schedule_expression = "rate(1 day)"
}



resource "aws_cloudwatch_event_target" "trigger_main" {
  rule      = aws_cloudwatch_event_rule.every_hour.name
  target_id = "lambda"
  arn       = aws_lambda_function.main_lambda.arn
}

resource "aws_cloudwatch_event_target" "trigger_delete" {
  rule      = aws_cloudwatch_event_rule.every_day.name
  target_id = "lambda"
  arn       = aws_lambda_function.delete_lambda.arn
}



resource "aws_lambda_permission" "allow_cloudwatch_to_call_main_function" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.main_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_hour.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_delete_function" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.delete_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_day.arn
}







