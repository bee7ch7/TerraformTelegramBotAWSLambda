data "archive_file" "TelegramWeatherBot" {
  type = "zip"

  source_dir  = "${path.module}/TelegramWeatherBot"
  output_path = "${path.module}/TelegramWeatherBot.zip"
}

resource "aws_s3_object" "TelegramWeatherBot" {
  bucket = aws_s3_bucket.telegramweatherbucket.id

  key    = "TelegramWeatherBot.zip"
  source = data.archive_file.TelegramWeatherBot.output_path

  etag = filemd5(data.archive_file.TelegramWeatherBot.output_path)
}