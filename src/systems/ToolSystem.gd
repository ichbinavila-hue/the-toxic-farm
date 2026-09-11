extends Node
class_name ToxicToolSystem

var tools := {
    "hoe": {"name": "Enxada", "power": 1},
    "watering_can": {"name": "Regador", "power": 1},
    "axe": {"name": "Machado", "power": 1},
    "pickaxe": {"name": "Picareta", "power": 1},
    "fishing_rod": {"name": "Vara de Pesca", "power": 1}
}

func upgrade(tool_id: String) -> bool:
    if not tools.has(tool_id):
        return false
    tools[tool_id]["power"] += 1
    return true

func get_power(tool_id: String) -> int:
    return int(tools.get(tool_id, {}).get("power", 0))
