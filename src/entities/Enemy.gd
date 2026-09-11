extends CharacterBody2D
class_name ToxicEnemy

@export var enemy_id := "slime"
var hp := 40
var speed := 55.0

func setup(id: String) -> void:
    enemy_id = id
    hp = CombatSystem.enemies.get(id, {"hp":40}).hp
    queue_redraw()

func _physics_process(delta: float) -> void:
    velocity = Vector2.ZERO
    move_and_slide()

func take_damage(amount: int) -> void:
    hp -= amount
    if hp <= 0:
        queue_free()

func _draw() -> void:
    draw_circle(Vector2.ZERO, 18, Color("#8dbf62"))
    draw_circle(Vector2(-6,-3), 3, Color("#222222"))
    draw_circle(Vector2(6,-3), 3, Color("#222222"))
