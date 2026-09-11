extends CanvasLayer

signal host_pressed
signal join_pressed(ip)
signal character_selected(id)
signal element_selected(id)
signal action_requested(action)
signal travel_requested(region_id)
signal craft_requested(recipe_id)

var status := "Offline — pronto para iniciar."
var selected_element := "spiritual"

func _ready() -> void:
    var panel = Panel.new()
    panel.name = "Panel"
    panel.position = Vector2(14,14)
    panel.size = Vector2(450,360)
    add_child(panel)

    var title = Label.new()
    title.position = Vector2(16,12)
    title.text = "THE TOXIC FARM — ONLINE"
    panel.add_child(title)

    var info = Label.new()
    info.position = Vector2(16,40)
    info.text = "WASD/Setas: mover   Espaço: magia   E: interagir"
    panel.add_child(info)

    var chars = OptionButton.new()
    chars.position = Vector2(16,75)
    chars.size = Vector2(190,32)
    for id in CharacterData.CHARACTERS:
        chars.add_item(CharacterData.CHARACTERS[id].name)
        chars.set_item_metadata(chars.item_count-1,id)
    chars.item_selected.connect(func(i): character_selected.emit(chars.get_item_metadata(i)))
    panel.add_child(chars)

    var elems = OptionButton.new()
    elems.position = Vector2(220,75)
    elems.size = Vector2(190,32)
    for id in ElementData.ELEMENTS:
        elems.add_item(ElementData.ELEMENTS[id].name)
        elems.set_item_metadata(elems.item_count-1,id)
    elems.item_selected.connect(func(i):
        selected_element = elems.get_item_metadata(i)
        element_selected.emit(selected_element))
    panel.add_child(elems)

    var host = Button.new()
    host.text = "ONLINE"
    host.position = Vector2(16,120)
    host.size = Vector2(95,32)
    host.pressed.connect(func(): host_pressed.emit())
    panel.add_child(host)

    var ip = LineEdit.new()
    ip.text = "wss://the-toxic-farm-server.onrender.com"
    ip.position = Vector2(120,120)
    ip.size = Vector2(290,32)
    panel.add_child(ip)

    var join = Button.new()
    join.text = "CONECTAR"
    join.position = Vector2(16,155)
    join.size = Vector2(110,32)
    join.pressed.connect(func(): join_pressed.emit(ip.text))
    panel.add_child(join)

    var day = Button.new()
    day.text = "Avançar dia"
    day.position = Vector2(16,200)
    day.size = Vector2(120,32)
    day.pressed.connect(func(): action_requested.emit("day"))
    panel.add_child(day)

    var fish = Button.new()
    fish.text = "Pescar"
    fish.position = Vector2(150,200)
    fish.size = Vector2(120,32)
    fish.pressed.connect(func(): action_requested.emit("fish"))
    panel.add_child(fish)

    var mine = Button.new()
    mine.text = "Minerar"
    mine.position = Vector2(284,200)
    mine.size = Vector2(126,32)
    mine.pressed.connect(func(): action_requested.emit("mine"))
    panel.add_child(mine)

    var travel = OptionButton.new()
    travel.position = Vector2(16,245)
    travel.size = Vector2(195,32)
    var regions = {"farm":"Fazenda","forest":"Floresta","village":"Vila","beach":"Praia","mine":"Mina","spirit":"Região Espiritual"}
    for id in regions:
        travel.add_item(regions[id])
        travel.set_item_metadata(travel.item_count-1,id)
    travel.item_selected.connect(func(i): travel_requested.emit(travel.get_item_metadata(i)))
    panel.add_child(travel)

    var craft = OptionButton.new()
    craft.position = Vector2(220,245)
    craft.size = Vector2(190,32)
    for id in CraftingSystem.RECIPES:
        craft.add_item(CraftingSystem.RECIPES[id].name)
        craft.set_item_metadata(craft.item_count-1,id)
    craft.item_selected.connect(func(i): craft_requested.emit(craft.get_item_metadata(i)))
    panel.add_child(craft)

    var status_label = Label.new()
    status_label.name = "Status"
    status_label.position = Vector2(16,295)
    status_label.size = Vector2(400,50)
    status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    status_label.text = status
    panel.add_child(status_label)

func set_status(value: String) -> void:
    status = value
    var label = get_node_or_null("Panel/Status")
    if label:
        label.text = value
