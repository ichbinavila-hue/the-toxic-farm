extends Node
class_name ToxicDayCycle

signal tick(hour: int, minute: int)
signal day_started(day: int)

var day := 1
var hour := 7
var minute := 0
var minutes_per_tick := 10

func advance_minutes(amount: int) -> void:
    var total := hour * 60 + minute + amount
    while total >= 24 * 60:
        total -= 24 * 60
        day += 1
        day_started.emit(day)
    hour = total / 60
    minute = total % 60
    tick.emit(hour, minute)

func get_time_text() -> String:
    return "%02d:%02d" % [hour, minute]
