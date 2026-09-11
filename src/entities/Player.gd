extends CharacterBody2D
class_name ToxicPlayer

@export var speed := 180.0
var peer_id := 1
var character_id := "pepitão"
var element_id := "spiritual"
var hp := 100
var max_hp := 100
var inventory := {}

func _ready() -> void:
    queue_redraw()

func _physics_process(delta: float) -> void:
    if peer_id != multiplayer.get_unique_id() and multiplayer.has_multiplayer_peer():
        return
    var input := Input.get_vector("move_left", "move_right", "move_up", "move_down")
    velocity = input * speed
    move_and_slide()
    global_position.x = clamp(global_position.x, 30.0, 1120.0)
    global_position.y = clamp(global_position.y, 30.0, 618.0)
    if Input.is_action_just_pressed("cast"):
        cast_element()
    if Input.is_action_just_pressed("interact"):
        interact()

func cast_element() -> void:
    var power = ElementData.get_element(element_id)
    print("%s [%s] lançou %s" % [character_id, power.name, power.ability])

func interact() -> void:
    print("%s interagiu." % character_id)

func _draw() -> void:
    var body_color := Color("#e9c46a")
    draw_circle(Vector2.ZERO, 13, body_color)
    draw_rect(Rect2(-10,-7,20,18), Color("#4b3b5d"))
    draw_circle(Vector2(-5,-2), 2.5, Color("#222222"))
    draw_circle(Vector2(5,-2), 2.5, Color("#222222"))
