extends Node
class_name RegionManager

signal region_changed(region_id)

const REGIONS := {
    "farm":{"name":"Fazenda","required_level":1},
    "forest":{"name":"Floresta","required_level":1},
    "village":{"name":"Vila","required_level":1},
    "beach":{"name":"Praia","required_level":2},
    "mine":{"name":"Mina","required_level":3},
    "spirit":{"name":"Região Espiritual","required_level":10}
}

var current_region := "farm"

func travel(region_id: String, level: int) -> bool:
    if not REGIONS.has(region_id):
        return false
    if level < int(REGIONS[region_id].required_level):
        return false
    current_region = region_id
    region_changed.emit(region_id)
    return true
