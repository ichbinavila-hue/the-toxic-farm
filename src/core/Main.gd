extends Node2D

const PlayerScene = preload("res://src/entities/Player.tscn")
const EnemyScene = preload("res://src/entities/Enemy.tscn")
const WorldMapScene = preload("res://src/world/WorldMap.tscn")
const HUDScene = preload("res://src/ui/HUD.tscn")
const Network = preload("res://src/network/Network.gd")

var world
var hud
var network
var players := {}
var progression := {}
var inventories := {}
var farm_system: FarmSystem
var animals: AnimalSystem
var crafting: CraftingSystem
var fishing: FishingSystem
var mining: MiningSystem
var regions: RegionManager
var world_state: WorldState

func _ready() -> void:
    farm_system = FarmSystem.new()
    add_child(farm_system)
    animals = AnimalSystem.new()
    add_child(animals)
    crafting = CraftingSystem.new()
    add_child(crafting)
    fishing = FishingSystem.new()
    add_child(fishing)
    mining = MiningSystem.new()
    add_child(mining)
    regions = RegionManager.new()
    add_child(regions)
    world_state = WorldState.new()
    add_child(world_state)

    world = WorldMapScene.instantiate()
    add_child(world)
    hud = HUDScene.instantiate()
    add_child(hud)
    network = Network.new()
    add_child(network)

    network.player_joined.connect(_on_player_joined)
    network.player_left.connect(_on_player_left)
    network.message.connect(_on_network_message)
    hud.host_pressed.connect(_host)
    hud.join_pressed.connect(_join)
    hud.character_selected.connect(_character_selected)
    hud.element_selected.connect(_element_selected)
    hud.action_requested.connect(_action_requested)
    hud.travel_requested.connect(_travel)
    hud.craft_requested.connect(_craft)

    _spawn_demo_enemy()
    _load_save()

func _host() -> void:
    network.host_game()
    hud.set_status("Host criado. Até 5 jogadores.")

func _join(ip: String) -> void:
    network.join_game(ip)
    hud.set_status("Conectando a %s..." % ip)

func _character_selected(id: String) -> void:
    network.send_message({"type":"character","value":id})

func _element_selected(id: String) -> void:
    network.send_message({"type":"element","value":id})

func _action_requested(action: String) -> void:
    var my_id := multiplayer.get_unique_id()
    if not inventories.has(my_id):
        return
    var inv: Inventory = inventories[my_id]
    var p = players.get(my_id)
    if action == "day":
        farm_system.advance_day()
        animals.advance_day()
        world_state.advance_day()
        _save()
        hud.set_status("Dia %d — %s. A fazenda avançou." % [world_state.day, world_state.season])
    elif action == "fish":
        var result = fishing.cast(p.element_id if p else "spiritual")
        inv.add(result.id, 1)
        _gain_xp(my_id, 20)
        hud.set_status("Você pescou %s! +20 XP." % result.name)
    elif action == "mine":
        var result = mining.mine(p.element_id if p else "spiritual")
        inv.add(result.id, result.amount)
        _gain_xp(my_id, 15)
        hud.set_status("Minerou %s x%d. +15 XP." % [result.id, result.amount])

func _travel(region_id: String) -> void:
    var id := multiplayer.get_unique_id()
    var level := progression[id].level if progression.has(id) else 1
    if regions.travel(region_id, level):
        hud.set_status("Viajando para: %s" % RegionManager.REGIONS[region_id].name)
    else:
        hud.set_status("Região bloqueada. Nível necessário.")

func _craft(recipe_id: String) -> void:
    var id := multiplayer.get_unique_id()
    if not inventories.has(id):
        return
    if crafting.craft(inventories[id], recipe_id):
        _gain_xp(id, 10)
        hud.set_status("Criado: %s." % CraftingSystem.RECIPES[recipe_id].name)
    else:
        hud.set_status("Materiais insuficientes.")

func _on_player_joined(peer_id: int) -> void:
    if players.has(peer_id):
        return
    var p = PlayerScene.instantiate()
    p.name = "Player_%s" % peer_id
    p.peer_id = peer_id
    p.position = Vector2(220 + (players.size()%3)*60, 250 + (players.size()/3)*70)
    world.add_child(p)
    players[peer_id] = p
    var prog := Progression.new()
    progression[peer_id] = prog
    var inv := Inventory.new()
    inv.add("wood", 15)
    inv.add("stone", 10)
    inv.add("turnip", 5)
    inventories[peer_id] = inv
    hud.set_status("Jogadores: %d/5" % players.size())

func _on_player_left(peer_id: int) -> void:
    if players.has(peer_id):
        players[peer_id].queue_free()
        players.erase(peer_id)
    progression.erase(peer_id)
    inventories.erase(peer_id)
    hud.set_status("Jogadores: %d/5" % players.size())

func _on_network_message(peer_id: int, data: Dictionary) -> void:
    if not players.has(peer_id):
        return
    var p = players[peer_id]
    match data.get("type"):
        "character":
            p.character_id = data.get("value","pepitão")
        "element":
            p.element_id = data.get("value","spiritual")
        "xp":
            _gain_xp(peer_id, int(data.get("amount",0)))

func _gain_xp(peer_id: int, amount: int) -> void:
    if not progression.has(peer_id):
        return
    var leveled = progression[peer_id].add_xp(amount)
    if leveled:
        hud.set_status("LEVEL UP! %s — nível %d" % [progression[peer_id].rank(), progression[peer_id].level])

func _spawn_demo_enemy() -> void:
    var enemy = EnemyScene.instantiate()
    enemy.setup("slime")
    enemy.position = Vector2(760,320)
    world.add_child(enemy)

func _save() -> void:
    var data := {
        "day":world_state.day,
        "money":world_state.money,
        "season":world_state.season,
        "crops":farm_system.crops
    }
    SaveSystem.save_world(data)

func _load_save() -> void:
    var data := SaveSystem.load_world()
    if data.is_empty():
        return
    world_state.day = int(data.get("day",1))
    world_state.money = int(data.get("money",500))
    world_state.season = str(data.get("season","spring"))
    farm_system.crops = data.get("crops",{})
