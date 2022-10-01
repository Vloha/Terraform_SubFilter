data "aws_iam_policy" "LambdaBasicExecutionRole" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"
  tags = {
    Name = "Role for Python Lambda function"
  }
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "Lambda_role_policy_attach" {
    role = aws_iam_role.iam_for_lambda.name
    policy_arn = data.aws_iam_policy.LambdaBasicExecutionRole.arn
}

resource "aws_lambda_function" "LogSubscriptionFunction" {
    filename = var.filename
    function_name = "analyzer"
    role = aws_iam_role.iam_for_lambda.arn
    handler = "function.handler"
    runtime = "python3.9"  
}