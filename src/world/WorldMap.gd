extends Node2D
class_name WorldMap

enum Region { FARM, FOREST, MINE, VILLAGE, BEACH, SPIRIT }

var current_region := Region.FARM

func set_region(region: int) -> void:
    current_region = region
    queue_redraw()

func _draw() -> void:
    draw_rect(Rect2(0,0,1152,648), Color("#1d3025"))
    draw_rect(Rect2(64,80,500,470), Color("#6e5235"))
    # Casa
    draw_rect(Rect2(190,115,180,120), Color("#8c6a50"))
    draw_rect(Rect2(250,175,60,60), Color("#40302a"))
    # Plantação
    for x in range(90,540,45):
        for y in range(285,510,45):
            draw_rect(Rect2(x,y,34,34), Color("#82603d"))
    # Lago
    draw_circle(Vector2(830,410), 115, Color("#376e7c"))
    # Árvores
    for pos in [Vector2(690,130),Vector2(790,150),Vector2(950,135),Vector2(1010,240)]:
        draw_circle(pos, 34, Color("#244c31"))
        draw_rect(Rect2(pos.x-5,pos.y+20,10,35), Color("#59402c"))
