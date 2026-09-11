extends Node
class_name ToxicRegionData

const REGIONS := {
    "farm": {"name": "Fazenda", "level": 1, "color": Color("#6d9f4d")},
    "forest": {"name": "Floresta", "level": 3, "color": Color("#3e7547")},
    "village": {"name": "Vila", "level": 1, "color": Color("#b78b58")},
    "beach": {"name": "Praia", "level": 5, "color": Color("#55a9b5")},
    "mine": {"name": "Minas", "level": 7, "color": Color("#59616b")},
    "spirit": {"name": "Região Espiritual", "level": 15, "color": Color("#6b4e88")}
}

func can_enter(id: String, level: int) -> bool:
    return REGIONS.has(id) and level >= int(REGIONS[id].level)

func display_name(id: String) -> String:
    return str(REGIONS.get(id, {}).get("name", id))
