extends CanvasLayer
class_name ToxicBetaHUD

var info: Label
var quests: Label
var toast: Label
var region: Label

func _ready() -> void:
    info = Label.new()
    info.position = Vector2(18, 16)
    info.add_theme_font_size_override("font_size", 16)
    add_child(info)

    region = Label.new()
    region.position = Vector2(18, 44)
    region.add_theme_font_size_override("font_size", 14)
    add_child(region)

    quests = Label.new()
    quests.position = Vector2(18, 76)
    quests.add_theme_font_size_override("font_size", 13)
    add_child(quests)

    toast = Label.new()
    toast.position = Vector2(18, 235)
    toast.add_theme_font_size_override("font_size", 18)
    add_child(toast)

func set_status(character: String, element: String, level: int, xp: int, gold: int, day: int, time_text: String, weather: String) -> void:
    info.text = "Dia %d  %s  |  %s  |  %s  |  Lv.%d  XP:%d  Ouro:%d" % [day, time_text, weather, character, level, xp, gold]

func set_region(name: String) -> void:
    region.text = "Região: " + name

func set_quests(active: Array) -> void:
    var lines := ["MISSÕES"]
    for q in active.slice(0, 4):
        var d = q.data
        lines.append("• %s [%d/%d]" % [d.title, d.progress, d.target])
    quests.text = "\n".join(lines)

func notify(message: String) -> void:
    toast.text = message
    var timer := get_tree().create_timer(2.5)
    timer.timeout.connect(func(): toast.text = "")
