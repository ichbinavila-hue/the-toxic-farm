extends Node
class_name WorldState

var day: int = 1
var money: int = 500
var season: String = "spring"

func advance_day() -> void:
    day += 1
    if day > 28:
        day = 1
        match season:
            "spring": season = "summer"
            "summer": season = "autumn"
            "autumn": season = "winter"
            "winter": season = "spring"
