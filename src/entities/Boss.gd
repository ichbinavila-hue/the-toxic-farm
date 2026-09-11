extends Node2D
class_name ToxicBoss

signal defeated
signal health_changed(current: int, maximum: int)

var boss_name := "Guardião Tóxico"
var max_health := 500
var health := 500
var phase := 1
var attack_timer := 0.0

func _ready() -> void:
    queue_redraw()

func _process(delta: float) -> void:
    attack_timer += delta
    if health <= max_health * 0.5:
        phase = 2
    queue_redraw()

func take_damage(amount: int) -> void:
    health = max(0, health - amount)
    health_changed.emit(health, max_health)
    if health == 0:
        defeated.emit()
        queue_free()

func _draw() -> void:
    draw_circle(Vector2.ZERO, 28.0, Color("#5c365f"))
    draw_circle(Vector2(0, -4), 19.0, Color("#7f4a7f"))
    draw_circle(Vector2(-8, -8), 4.0, Color("#e6f37d"))
    draw_circle(Vector2(8, -8), 4.0, Color("#e6f37d"))
    draw_rect(Rect2(-18, 10, 36, 5), Color("#2a1e2c"))
    draw_rect(Rect2(-18, 10, 36 * (float(health) / max_health), 5), Color("#e15d63"))
