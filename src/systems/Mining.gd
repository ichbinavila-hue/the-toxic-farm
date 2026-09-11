extends Node
class_name MiningSystem

const ORES := {
    "stone":{"value":3},
    "iron":{"value":12},
    "water_crystal":{"value":40},
    "spirit_shard":{"value":75}
}

func mine(element_id: String) -> Dictionary:
    var keys := ORES.keys()
    var id: String = keys[randi() % keys.size()]
    var amount := 1
    if element_id == "fire" or element_id == "earth":
        amount = 2
    return {"id":id, "amount":amount}
