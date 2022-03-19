resource "aws_lambda_function" "TelegramWeatherBot" {
  function_name = "TelegramWeatherBot"

  s3_bucket = aws_s3_bucket.telegramweatherbucket.id
  s3_key    = aws_s3_object.TelegramWeatherBot.key

  runtime = "python3.9"
  handler = "lambda_function.lambda_handler"

  source_code_hash = data.archive_file.TelegramWeatherBot.output_base64sha256

  role = aws_iam_role.lambda_exec.arn
  
  environment {
    variables = {
      TG_TOKEN = var.telegram_token
      WEATHER_TOKEN = var.weather_token
    }
  }

}

resource "aws_cloudwatch_log_group" "TelegramWeatherBot" {
  name = "/aws/lambda/${aws_lambda_function.TelegramWeatherBot.function_name}"

  retention_in_days = 3
}

resource "aws_iam_role" "lambda_exec" {
  name = "serverless_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}