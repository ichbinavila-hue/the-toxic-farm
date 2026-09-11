extends Node
class_name CraftingSystem

const RECIPES := {
    "wooden_hoe":{"name":"Enxada de Madeira","ingredients":{"wood":5,"stone":2}},
    "watering_can":{"name":"Regador","ingredients":{"wood":3,"iron":2}},
    "campfire":{"name":"Fogueira","ingredients":{"wood":10,"stone":5}},
    "spirit_lantern":{"name":"Lanterna Espiritual","ingredients":{"iron":3,"spirit_shard":2}}
}

func can_craft(inventory: Inventory, recipe_id: String) -> bool:
    if not RECIPES.has(recipe_id):
        return false
    for item in RECIPES[recipe_id].ingredients:
        if not inventory.has(item, RECIPES[recipe_id].ingredients[item]):
            return false
    return true

func craft(inventory: Inventory, recipe_id: String) -> bool:
    if not can_craft(inventory, recipe_id):
        return false
    for item in RECIPES[recipe_id].ingredients:
        inventory.remove(item, RECIPES[recipe_id].ingredients[item])
    inventory.add(recipe_id, 1)
    return true
