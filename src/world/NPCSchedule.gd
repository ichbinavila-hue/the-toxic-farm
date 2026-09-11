extends Node
class_name ToxicNPCSchedule

var schedules := {
    "Mara": [
        {"from": 7, "to": 10, "place": "village_square"},
        {"from": 10, "to": 16, "place": "village_shop"},
        {"from": 16, "to": 20, "place": "village_square"}
    ],
    "Téo": [
        {"from": 7, "to": 12, "place": "village_workshop"},
        {"from": 12, "to": 18, "place": "mine_entrance"},
        {"from": 18, "to": 22, "place": "village_square"}
    ],
    "Luna": [
        {"from": 8, "to": 12, "place": "forest_edge"},
        {"from": 12, "to": 17, "place": "village_square"},
        {"from": 17, "to": 22, "place": "forest_edge"}
    ]
}

func place_for(npc_name: String, hour: int) -> String:
    for entry in schedules.get(npc_name, []):
        if hour >= entry.from and hour < entry.to:
            return entry.place
    return "home"
