extends Node
class_name ToxicWebSocketMultiplayer

signal player_joined(peer_id: int, player_data: Dictionary)
signal player_left(peer_id: int)
signal world_state_received(state: Dictionary)
signal chat_received(peer_id: int, text: String)

var client: ToxicWebSocketClient
var peer_id := 0
var players: Dictionary = {}

func _ready() -> void:
    client = ToxicWebSocketClient.new()
    add_child(client)
    client.message_received.connect(_on_message)

func connect_online(url: String, player_name: String, character: String, element: String) -> void:
    client.connect_to_server(url)
    await client.connected
    client.send_json({
        "type": "join",
        "name": player_name,
        "character": character,
        "element": element
    })

func send_position(position: Vector2, region: String) -> void:
    client.send_json({
        "type": "position",
        "x": position.x,
        "y": position.y,
        "region": region
    })

func send_action(action: String, payload: Dictionary = {}) -> void:
    var msg := {"type": "action", "action": action}
    msg.merge(payload)
    client.send_json(msg)

func send_chat(text: String) -> void:
    client.send_json({"type": "chat", "text": text})

func _on_message(msg: Dictionary) -> void:
    match str(msg.get("type", "")):
        "welcome":
            peer_id = int(msg.get("peer_id", 0))
            players = msg.get("players", {})
        "player_joined":
            var id := int(msg.get("peer_id", 0))
            players[id] = msg.get("player", {})
            player_joined.emit(id, players[id])
        "player_left":
            var id := int(msg.get("peer_id", 0))
            players.erase(id)
            player_left.emit(id)
        "world":
            world_state_received.emit(msg.get("state", {}))
        "chat":
            chat_received.emit(int(msg.get("peer_id", 0)), str(msg.get("text", "")))
