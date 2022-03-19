import os

def telegram_secret():
  telegram_secret.token = os.environ['TG_TOKEN']
  telegram_secret.weather = os.environ['WEATHER_TOKEN']