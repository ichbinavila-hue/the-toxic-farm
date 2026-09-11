extends Panel
class_name InventoryUI

var inventory: Inventory
var label: Label

func setup(inv: Inventory) -> void:
    inventory = inv
    label = Label.new()
    label.position = Vector2(12,12)
    add_child(label)
    refresh()

func refresh() -> void:
    if label == null:
        return
    var text := "INVENTÁRIO\n"
    if inventory == null or inventory.items.is_empty():
        text += "(vazio)"
    else:
        for id in inventory.items:
            text += "%s x%d\n" % [id, inventory.items[id]]
    label.text = text
