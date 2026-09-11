extends Node

func _ready() -> void:
    var q := ToxicQuestSystem.new()
    assert(q.quests.size() >= 4)
    q.add_progress("first_harvest", 3)
    assert(q.is_complete("first_harvest"))

    var w := ToxicWeatherSystem.new()
    w.advance_day(3)
    assert(w.weather == "Rainy")

    var d := ToxicDayCycle.new()
    d.advance_minutes(60)
    assert(d.hour == 8)

    print("Beta systems smoke test: OK")
    get_tree().quit()
