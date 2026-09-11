extends Node2D

var soil := {}
var crops := {}

func _ready() -> void:
    queue_redraw()

func _draw() -> void:
    draw_rect(Rect2(0,0,1152,648), Color("#28452f"))
    draw_rect(Rect2(80,110,520,410), Color("#6d5334"))
    draw_rect(Rect2(640,80,430,480), Color("#365d3e"))
    for x in range(100, 580, 48):
        for y in range(130, 500, 48):
            draw_rect(Rect2(x,y,38,38), Color("#80613c"))

func plant(tile: Vector2i, seed_id: String) -> bool:
    if crops.has(tile):
        return false
    crops[tile] = {"seed":seed_id, "growth":0, "watered":false}
    return true

func water(tile: Vector2i) -> bool:
    if not crops.has(tile):
        return false
    crops[tile].watered = true
    return true

func grow_day() -> void:
    for tile in crops:
        if crops[tile].watered:
            crops[tile].growth += 1
            crops[tile].watered = false
