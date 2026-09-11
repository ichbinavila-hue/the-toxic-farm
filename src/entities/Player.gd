extends CharacterBody2D
class_name ToxicPlayer

@export var speed := 180.0
var peer_id := 1
var character_id := "pepitão"
var element_id := "spiritual"
var hp := 100
var max_hp := 100
var inventory := {}
var network: ToxicNetwork
var _position_send_timer := 0.0
var _remote_target := Vector2.ZERO

func _ready() -> void:
    _remote_target = global_position
    queue_redraw()

func _physics_process(delta: float) -> void:
    if network == null or peer_id != network.local_peer_id():
        if network != null:
            global_position = global_position.lerp(_remote_target, min(delta * 12.0, 1.0))
        return
    var input := Input.get_vector("move_left", "move_right", "move_up", "move_down")
    velocity = input * speed
    move_and_slide()
    global_position.x = clamp(global_position.x, 30.0, 1120.0)
    global_position.y = clamp(global_position.y, 30.0, 618.0)
    _position_send_timer -= delta
    if _position_send_timer <= 0.0:
        _position_send_timer = 0.05
        network.send_position(global_position)
    if Input.is_action_just_pressed("cast"):
        cast_element()
    if Input.is_action_just_pressed("interact"):
        interact()

func set_remote_position(value: Vector2) -> void:
    _remote_target = value

func cast_element() -> void:
    var power = ElementData.get_element(element_id)
    print("%s [%s] lançou %s" % [character_id, power.name, power.ability])
    if network != null:
        network.send_action("cast", {"element":element_id})

func interact() -> void:
    print("%s interagiu." % character_id)
    if network != null:
        network.send_action("interact")

func _draw() -> void:
    var body_color := Color("#e9c46a")
    draw_circle(Vector2.ZERO, 13, body_color)
    draw_rect(Rect2(-10,-7,20,18), Color("#4b3b5d"))
    draw_circle(Vector2(-5,-2), 2.5, Color("#222222"))
    draw_circle(Vector2(5,-2), 2.5, Color("#222222"))
