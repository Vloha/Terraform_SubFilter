resource "aws_cloudwatch_log_group" "generator" {
  name = "/aws/lambda/generator"
  retention_in_days = 14
}
resource "aws_cloudwatch_log_stream" "test" {
  name           = "test"
  log_group_name = aws_cloudwatch_log_group.generator.name
}