#!/bin/bash

codes=$(cat <<EOM
{
  "0" : "Clear sky",
  "1" : "Mainly clear",
  "2" : "Partly cloudy",
  "3" : "Overcast",
  "45": "Fog",
  "48": "Depositing rime fog",
  "51": "Drizzle: Light",
  "53": "Drizzle: Moderate",
  "55": "Drizzle: Dense intensity",
  "56": "Freezing Drizzle: Light",
  "57": "Freezing Drizzle: Dense intensity",
  "61": "Rain: Slight",
  "63": "Rain: Moderate",
  "65": "Rain: Heavy intensity",
  "66": "Freezing Rain: Light",
  "67": "Freezing Rain: Heavy intensity",
  "71": "Snow fall: Slight",
  "73": "Snow fall: Moderate",
  "75": "Snow fall: Heavy intensity",
  "77": "Snow grains",
  "80": "Rain showers: Slight",
  "81": "Rain showers: Moderate",
  "82": "Rain showers: Violent",
  "85": "Snow showers: Slight",
  "86": "Snow showers: Heavy",
  "95": "Thunderstorm: Slight or moderate",
  "96": "Thunderstorm with slight hail",
  "99": "Thunderstorm with heavy hail"
}
EOM
)

symbols=$(cat <<EOM
{
  "0" : "☀️",
  "1" : "☁️",
  "2" : "⛅",
  "3" : "🌥️",
  "45": "🌫",
  "48": "🌨",
  "51": "🌦️",
  "53": "🌧️",
  "55": "🌧",
  "56": "Freezing Drizzle: Light",
  "57": "Freezing Drizzle: Dense intensity",
  "61": "🌦️",
  "63": "🌧️",
  "65": "🌧️",
  "66": "Freezing Rain: Light",
  "67": "Freezing Rain: Heavy intensity",
  "71": "Snow fall: Slight",
  "73": "Snow fall: Moderate",
  "75": "Snow fall: Heavy intensity",
  "77": "Snow grains",
  "80": "🌦️",
  "81": "🌧️",
  "82": "🌧",
  "85": "Snow showers: Slight",
  "86": "Snow showers: Heavy",
  "95": "⛈️",
  "96": "Thunderstorm with slight hail",
  "99": "Thunderstorm with heavy hail"
}
EOM
)

opt='current=temperature_2m,weather_code,apparent_temperature,relative_humidity_2m'
loc='latitude=15.619299&longitude=73.8442'
info=$(curl --silent \
	"https://api.open-meteo.com/v1/forecast?$loc&$opt")

# {
#   "latitude": 15.625,
#   "longitude": 73.875,
#   "generationtime_ms": 0.05793571472167969,
#   "utc_offset_seconds": 0,
#   "timezone": "GMT",
#   "timezone_abbreviation": "GMT",
#   "elevation": 7.0,
#   "current_units": {
#     "time": "iso8601",
#     "interval": "seconds",
#     "temperature_2m": "°C",
#     "weather_code": "wmo code",
#     "apparent_temperature": "°C",
#     "relative_humidity_2m": "%"
#   },
#   "current": {
#     "time": "2025-05-23T17:45",
#     "interval": 900,
#     "temperature_2m": 27.1,
#     "weather_code": 95,
#     "apparent_temperature": 33.2,
#     "relative_humidity_2m": 93
#   }
# }

code=$(echo "$info" | jq '.current.weather_code')
condition=$(echo "$codes" | jq ".\"$code\"" --raw-output)
symbol=$(echo "$symbols"  | jq ".\"$code\"" --raw-output)
temp=$(echo "$info" | jq '.current.temperature_2m')
feels_like=$(echo "$info" | jq '.current.apparent_temperature' --raw-output)

temp_unit=$(echo "$info" | jq '.current_units.temperature_2m' --raw-output)

printf "$symbol $temp$temp_unit\n$condition\rFeels Like: $feels_like$temp_unit"

