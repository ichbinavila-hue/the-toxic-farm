extends Node
class_name WorldState

signal day_changed(day)
signal money_changed(amount)

var day := 1
var money := 500
var season := "spring"
var weather := "clear"

func advance_day() -> void:
    day += 1
    if day > 28:
        day = 1
        season = _next_season(season)
    day_changed.emit(day)

func add_money(amount: int) -> void:
    money += amount
    money_changed.emit(money)

func _next_season(value: String) -> String:
    return {"spring":"summer","summer":"autumn","autumn":"winter","winter":"spring"}.get(value,"spring")
