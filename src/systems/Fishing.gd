extends Node
class_name FishingSystem

const FISH := {
    "small_fish":{"name":"Peixe Pequeno","value":25},
    "blue_fish":{"name":"Peixe Azul","value":50},
    "moon_fish":{"name":"Peixe Lunar","value":150}
}

func cast(element_id: String) -> Dictionary:
    var keys := FISH.keys()
    var fish_id: String = keys[randi() % keys.size()]
    var fish: Dictionary = FISH[fish_id].duplicate()
    if element_id == "water":
        fish["value"] = int(fish.value * 1.25)
    fish["id"] = fish_id
    return fish
