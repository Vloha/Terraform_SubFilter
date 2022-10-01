resource "aws_lambda_permission" "SubFilter" {
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.LogSubscriptionFunction.function_name
    principal = "logs.your_region.amazonaws.com"
    source_arn = "${aws_cloudwatch_log_group.generator.arn}:*"
}

resource "aws_cloudwatch_log_subscription_filter" "Find_Error" {
    depends_on = [aws_lambda_permission.SubFilter]
    name = "Find ERROR"
    log_group_name  = aws_cloudwatch_log_group.generator.name
    filter_pattern  = "ERROR"
    destination_arn = aws_lambda_function.LogSubscriptionFunction.arn
}

