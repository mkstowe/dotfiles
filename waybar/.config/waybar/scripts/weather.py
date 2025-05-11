#!/usr/bin/env python

import json
import requests
from datetime import datetime

API_KEY = "16a924c654ff0e555f921a43d62a31d5"
LATITUDE = "42.9552864"
LONGITUDE = "-85.6453181"
UNITS = "imperial"
EXCLUDE = "minutely,hourly"
ICON_CODES = {
    '01d': '󰖙',
    '01n': '󰖔',
    '02d': '',
    '02n': '󰼱',
    '03d': '',
    '03n': '',
    '04d': '',
    '04n': '',
    '09d': '',
    '09n': '',
    '10d': '',
    '10n': '',
    '11d': '',
    '11n': '',
    '13d': '',
    '13n': '',
    '50d': '',
    '50n': ''
}


def get_weather():
    api_call = f"https://api.openweathermap.org/data/2.5/onecall?appid={ API_KEY }&lat={ LATITUDE }&lon={ LONGITUDE }&units={ UNITS }&exclude={ EXCLUDE }"

    data = {}
    weather = requests.get(api_call).json()

    current_weather = weather['current']['weather'][0]

    data['text'] = f"{ ICON_CODES[current_weather['icon']] }  { round(weather['current']['temp']) }°"

    data['tooltip'] = f"Today:  \n  { ICON_CODES[current_weather['icon']] } { current_weather['description'].capitalize() }  \n  Feels Like: { round(weather['current']['feels_like']) }°  \n  High: { round(weather['daily'][0]['temp']['max']) }° | Low: { round(weather['daily'][0]['temp']['min']) }°  \n  Precipitation: { round(weather['daily'][0]['pop'] * 100) }% chance \n  Humidity: { weather['current']['humidity'] }%  \n  Wind: { round(weather['current']['wind_speed']) }mph  \n"

    if 'alerts' in weather['current']:
            data['tooltip'] += f"Alerts: { weather['current']['alerts'].join(', ') }  "

    for i, day in enumerate(weather['daily']):
        if i == 0:
            continue

        date = datetime.fromtimestamp(day['dt'])
        data['tooltip'] += f"\n{ date.strftime('%A') } { date.strftime('%m').lstrip('0') }/{ date.strftime('%d').lstrip('0') }:  \n  { ICON_CODES[day['weather'][0]['icon']] } { day['weather'][0]['description'].capitalize() }  \n  High: { round(day['temp']['max']) }° | Low: { round(day['temp']['min']) }°  \n  Precipitation: { round(day['pop'] * 100) }% chance  \n  Humidity: { day['humidity'] }%  \n  Wind: { round(day['wind_speed']) }mph  \n"

    return data


print(json.dumps(get_weather()))
