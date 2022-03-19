resource "aws_apigatewayv2_api" "TelegramWeatherBot" {
  name          = "TelegramWeatherBot"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "TelegramWeatherBot" {
  api_id = aws_apigatewayv2_api.TelegramWeatherBot.id

  name        = "TelegramWeatherBot"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
}

resource "aws_apigatewayv2_integration" "TelegramWeatherBot" {
  api_id = aws_apigatewayv2_api.TelegramWeatherBot.id
  payload_format_version = "2.0"

  integration_uri    = aws_lambda_function.TelegramWeatherBot.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "TelegramWeatherBot" {
  api_id = aws_apigatewayv2_api.TelegramWeatherBot.id

  route_key = "ANY /TelegramWeatherBot"
  target    = "integrations/${aws_apigatewayv2_integration.TelegramWeatherBot.id}"
}

resource "aws_cloudwatch_log_group" "api_gw" {
  name = "/aws/api_gw"

  retention_in_days = 3
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.TelegramWeatherBot.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.TelegramWeatherBot.execution_arn}/*/*/${aws_lambda_function.TelegramWeatherBot.function_name}"
}