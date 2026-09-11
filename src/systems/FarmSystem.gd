extends Node
class_name FarmSystem

signal crop_changed(tile, crop)

var crops: Dictionary = {}

func plant(tile: Vector2i, seed_id: String) -> bool:
    if crops.has(tile) or not GameData.SEEDS.has(seed_id):
        return false
    crops[tile] = {
        "seed": seed_id,
        "growth": 0,
        "watered": false,
        "ready": false
    }
    crop_changed.emit(tile, crops[tile])
    return true

func water(tile: Vector2i) -> bool:
    if not crops.has(tile):
        return false
    crops[tile].watered = true
    crop_changed.emit(tile, crops[tile])
    return true

func advance_day() -> void:
    for tile in crops.keys():
        var crop: Dictionary = crops[tile]
        if crop.watered:
            crop.growth += 1
            crop.watered = false
            var info: Dictionary = GameData.SEEDS[crop.seed]
            crop.ready = crop.growth >= int(info.days)
            crops[tile] = crop
            crop_changed.emit(tile, crop)

func harvest(tile: Vector2i) -> String:
    if not crops.has(tile) or not crops[tile].ready:
        return ""
    var seed_id: String = crops[tile].seed
    crops.erase(tile)
    crop_changed.emit(tile, {})
    return seed_id
