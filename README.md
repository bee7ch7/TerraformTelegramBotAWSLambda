# Terraform script to build zip archive with TelegramBot written on python
Tested with python 3.9 version

For usage file <filename.tfvars> needed with secrets:
```
weather_token = "xxx"
telegram_token = "xxx"
access_key = "xxx"
secret_key = "xxx"

weather_token - can be obtained by https://openweathermap.org/
telegram_token - you can generated id directly in telegram with BotFather bot
access_key and secret_key - can be obtained in AWS console

```
And atfer run terraform apply:
```
terraform apply -var-file="<filename.tfvars>"
```
After apply you will get the base_url and function name
```
Apply complete! Resources: 13 added, 0 changed, 0 destroyed.

Outputs:

base_url = "https://xxxxx.execute-api.eu-central-1.amazonaws.com/TelegramWeatherBot"
function_name = "TelegramWeatherBot"
```
The webhook with data above must be set for your telegram bot
In this example it will looks like base_url + route_path:
```
https://xxxxx.execute-api.eu-central-1.amazonaws.com/TelegramWeatherBot/TelegramWeatherBot
```
It is recommended to delete webhook first to be sure nothing was applied before. Simply open the link below in any web browser:
```
https://api.telegram.org/bot<telegram_bot_id>/deleteWebhook
```
To set new webhook create the link:
```
https://api.telegram.org/bot<telegram_bot_id>/setWebhook?url=https://xxxxx.execute-api.eu-central-1.amazonaws.com/TelegramWeatherBot/TelegramWeatherBot
```
All is done, you can say "hi" or "/help" to bot 
