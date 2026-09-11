extends Node
class_name Inventory

var items: Dictionary = {}
const MAX_STACK := 999

func add(item_id: String, amount: int = 1) -> void:
    items[item_id] = min(MAX_STACK, items.get(item_id,0) + amount)

func remove(item_id: String, amount: int = 1) -> bool:
    if items.get(item_id,0) < amount:
        return false
    items[item_id] -= amount
    if items[item_id] <= 0:
        items.erase(item_id)
    return true

func has(item_id: String, amount: int = 1) -> bool:
    return items.get(item_id,0) >= amount
