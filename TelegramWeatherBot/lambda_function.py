import datetime
import urllib.request
import requests
import telebot
import json
from secrets import telegram_secret

telegram_secret()

RESPONSE_200 = {
    "statusCode" : 200,
    "headers": "",
    "body": ""
}

def lambda_handler(event, context):
    
    tele_token = telegram_secret.token
    weather_token = telegram_secret.weather

    print(event)
    
    update = telebot.types.JsonDeserializable.check_json(event["body"])
    message = update.get('message')
    received_text = message.get('text')
    chat = message.get('chat')

    print(received_text)
    
    bot = telebot.TeleBot(tele_token, threaded=False)

    hi_list = (
        'hello',
        'helo',
        'privet',
        'yo',
        'hi',
        'Hi',
        'привет',
        'йо',
        'йоу',
        'привіт'
    )

    if received_text.lower() in hi_list:
      bot.send_message(chat['id'],
                       "Oh, hi! Send me a city name in English and I will tell you the weather for now :)")
    elif received_text.lower() == "/help":
      bot.send_message(chat['id'], "Type 'hello'")

    elif isinstance(received_text.lower(), str) and len(received_text.lower()) <= 10:
        #req_city = message.text
        req_city = ''.join(e for e in received_text.lower() if e.isalnum())
        
        url_prepare = f"https://api.openweathermap.org/data/2.5/weather?q={req_city}&appid={weather_token}&units=metric"

        check = requests.get(url_prepare)

        if check.status_code != 200:
            bot.send_message(chat['id'], "I don't know such city, try European one!\nOnly latin chars are accepted")
        else:
        
            link = urllib.request.urlopen(url_prepare)
            data = json.loads(link.read().decode())
        #print(data)

            if data['cod'] == '404':
                err = data['message']
                bot.send_message(chat['id'], err)

            else:

                temp = data['main']['temp']
                feels_like = data['main']['feels_like']
                city = data['name']
                epoch_time = data['dt']
                date_time = datetime.datetime.fromtimestamp(epoch_time)

                line1 = f"Your choice is: {city}\n"
                line2 = f"Current temp is: {temp}\n"
                line3 = f"Feels like: {feels_like}\n"
                line4 = f"Updated at: {date_time}"
                to_send = line1 + line2 + line3 + line4
                bot.send_message(chat['id'], to_send)
    else:
        bot.send_message(chat['id'],
                        "Type /help.")


