extends Node2D

var controller: ToxicBetaController
var hud: ToxicBetaHUD
var player: Node2D

func _ready() -> void:
    controller = ToxicBetaController.new()
    add_child(controller)

    hud = ToxicBetaHUD.new()
    add_child(hud)

    player = Node2D.new()
    player.position = Vector2(480, 300)
    add_child(player)
    player.queue_redraw()

    controller.status_changed.connect(refresh)
    controller.toast.connect(hud.notify)
    controller.quest_system.signal_quest_updated.connect(refresh)
    refresh()

func _process(delta: float) -> void:
    if player:
        var input := Input.get_vector("move_left", "move_right", "move_up", "move_down")
        player.position += input * 150.0 * delta
        player.position.x = clamp(player.position.x, 30.0, 930.0)
        player.position.y = clamp(player.position.y, 70.0, 510.0)
        player.queue_redraw()

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("interact"):
        controller.complete_harvest(1)
        hud.notify("Colheita registrada! (+ouro / +XP)")
    if event.is_action_pressed("cast"):
        controller.spirit_find(1)
        hud.notify("Você sentiu a presença espiritual...")
    if event is InputEventKey and event.pressed and event.keycode == KEY_F:
        controller.advance_time(30)
        hud.notify("O tempo avançou 30 minutos.")
    if event is InputEventKey and event.pressed and event.keycode == KEY_M:
        controller.mine()
        hud.notify("Minério coletado! (+ouro / +XP)")
    if event is InputEventKey and event.pressed and event.keycode == KEY_1:
        controller.enter_region("forest")
    if event is InputEventKey and event.pressed and event.keycode == KEY_2:
        controller.enter_region("beach")
    if event is InputEventKey and event.pressed and event.keycode == KEY_3:
        controller.enter_region("mine")
    if event is InputEventKey and event.pressed and event.keycode == KEY_4:
        controller.enter_region("spirit")

func refresh() -> void:
    hud.set_status(
        controller.selected_character,
        controller.selected_element,
        controller.level,
        controller.xp,
        controller.gold,
        controller.day,
        controller.day_cycle.get_time_text(),
        controller.weather_system.weather
    )
    hud.set_region(controller.current_region)
    hud.set_quests(controller.quest_system.get_active())

func _draw() -> void:
    # mapa beta simples e legível
    draw_rect(Rect2(0, 0, 960, 540), Color("#202b2b"))
    draw_rect(Rect2(25, 70, 910, 445), Color("#6d9f4d"))
    draw_rect(Rect2(25, 70, 910, 90), Color("#5d8b45"))
    for x in range(70, 900, 70):
        draw_rect(Rect2(x, 190, 52, 42), Color("#805d3e"))
        draw_circle(Vector2(x + 20, 180), 15, Color("#376c45"))
        draw_circle(Vector2(x + 35, 175), 12, Color("#477e4f"))
    draw_rect(Rect2(50, 380, 250, 105), Color("#86b95d"))
    draw_string(ThemeDB.fallback_font, Vector2(62, 405), "ÁREA DE PLANTIO", HORIZONTAL_ALIGNMENT_LEFT, -1, 14, Color("#24321e"))
    draw_string(ThemeDB.fallback_font, Vector2(650, 490), "F = tempo  M = mina  1-4 = regiões", HORIZONTAL_ALIGNMENT_LEFT, -1, 13, Color("#f0ead9"))
