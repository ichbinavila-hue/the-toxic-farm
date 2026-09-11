extends Node
class_name ToxicBetaController

var gold := 250
var current_region := "farm"
var selected_character := "Pepitão"
var selected_element := "Spiritual"
var level := 1
var xp := 0
var day := 1

var quest_system: ToxicQuestSystem
var weather_system: ToxicWeatherSystem
var day_cycle: ToxicDayCycle
var shop_system: ToxicShopSystem
var tool_system: ToxicToolSystem

signal status_changed
signal toast(message: String)

func _ready() -> void:
    quest_system = ToxicQuestSystem.new()
    weather_system = ToxicWeatherSystem.new()
    day_cycle = ToxicDayCycle.new()
    shop_system = ToxicShopSystem.new()
    tool_system = ToxicToolSystem.new()
    add_child(quest_system)
    add_child(weather_system)
    add_child(day_cycle)
    add_child(shop_system)
    add_child(tool_system)

    day_cycle.day_started.connect(_on_day_started)
    weather_system.advance_day(day)

func gain_xp(amount: int) -> void:
    xp += amount
    while xp >= level * 100:
        xp -= level * 100
        level += 1
        toast.emit("Subiu para o nível %d!" % level)
    status_changed.emit()

func earn_gold(amount: int) -> void:
    gold += amount
    status_changed.emit()

func spend_gold(amount: int) -> bool:
    if gold < amount:
        return false
    gold -= amount
    status_changed.emit()
    return true

func complete_harvest(amount: int) -> void:
    quest_system.add_progress("first_harvest", amount)
    gain_xp(15 * amount)
    earn_gold(20 * amount)

func enter_region(id: String) -> bool:
    var req := {"farm": 1, "forest": 3, "village": 1, "beach": 5, "mine": 7, "spirit": 15}
    if not req.has(id) or level < req[id]:
        toast.emit("Região bloqueada. Nível necessário: %d" % req.get(id, 1))
        return false
    current_region = id
    if id == "village":
        quest_system.add_progress("meet_village")
    toast.emit("Entrou em " + id)
    status_changed.emit()
    return true

func mine(amount := 1) -> void:
    quest_system.add_progress("mine_depths", amount)
    gain_xp(12 * amount)
    earn_gold(18 * amount)

func spirit_find(amount := 1) -> void:
    quest_system.add_progress("spirit_signal", amount)
    gain_xp(20 * amount)
    earn_gold(35 * amount)

func advance_time(minutes := 30) -> void:
    day_cycle.advance_minutes(minutes)
    status_changed.emit()

func _on_day_started(new_day: int) -> void:
    day = new_day
    weather_system.advance_day(day)
    status_changed.emit()
