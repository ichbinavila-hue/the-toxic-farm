extends Node
class_name ToxicWeatherSystem

signal weather_changed(name: String)

var day := 1
var weather := "Sunny"
var forecast := ["Sunny", "Cloudy", "Rainy", "Windy", "Spirit Mist"]

func advance_day(new_day: int) -> void:
    day = new_day
    weather = forecast[(day - 1) % forecast.size()]
    weather_changed.emit(weather)

func is_raining() -> bool:
    return weather == "Rainy"

func farming_bonus() -> float:
    if weather == "Rainy":
        return 1.20
    if weather == "Spirit Mist":
        return 1.10
    return 1.0
