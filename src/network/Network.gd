extends Node
class_name ToxicNetwork

signal player_joined(peer_id)
signal player_left(peer_id)
signal message(peer_id, data)

const SERVER_URL := "wss://the-toxic-farm-server.onrender.com"
const MAX_PLAYERS := 5
var socket: WebSocketPeer
var _local_peer_id := 0
var _last_state := WebSocketPeer.STATE_CLOSED

func _ready() -> void:
    set_process(true)

func _process(_delta: float) -> void:
    if socket == null:
        return
    socket.poll()
    var state := socket.get_ready_state()
    if state != _last_state:
        _last_state = state
        if state == WebSocketPeer.STATE_OPEN:
            _send({"type":"join", "name":"Jogador %d" % max(_local_peer_id, 1)})
    if state == WebSocketPeer.STATE_OPEN:
        while socket.get_available_packet_count() > 0:
            var raw := socket.get_packet().get_string_from_utf8()
            var data = JSON.parse_string(raw)
            if data is Dictionary:
                _handle(data)

func host_game() -> void:
    connect_to_server(SERVER_URL)

func join_game(url: String) -> void:
    var target := url.strip_edges()
    if target.is_empty() or target == "127.0.0.1" or target == "localhost":
        target = SERVER_URL
    if target.begins_with("http://"):
        target = "ws://" + target.trim_prefix("http://")
    elif target.begins_with("https://"):
        target = "wss://" + target.trim_prefix("https://")
    elif not target.begins_with("ws://") and not target.begins_with("wss://"):
        target = "wss://" + target
    connect_to_server(target)

func connect_to_server(url: String) -> void:
    if socket != null:
        socket.close()
    socket = WebSocketPeer.new()
    _local_peer_id = 0
    _last_state = WebSocketPeer.STATE_CONNECTING
    var err := socket.connect_to_url(url)
    if err != OK:
        push_error("Falha ao conectar ao servidor WebSocket: %s" % err)

func local_peer_id() -> int:
    return _local_peer_id

func is_connected() -> bool:
    return socket != null and socket.get_ready_state() == WebSocketPeer.STATE_OPEN

func send_message(data: Dictionary) -> void:
    _send(data)

func send_position(position: Vector2, region := "farm") -> void:
    _send({"type":"position", "x":position.x, "y":position.y, "region":region})

func send_action(action: String, payload := {}) -> void:
    _send({"type":"action", "action":action, "payload":payload})

func _send(data: Dictionary) -> void:
    if not is_connected():
        return
    socket.send_text(JSON.stringify(data))

func _handle(data: Dictionary) -> void:
    match str(data.get("type", "")):
        "welcome":
            _local_peer_id = int(data.get("peer_id", 0))
            var existing: Dictionary = data.get("players", {})
            for key in existing.keys():
                var id := int(key)
                player_joined.emit(id)
                message.emit(id, {"type":"player_state", "player":existing[key]})
        "player_joined":
            var id := int(data.get("peer_id", 0))
            player_joined.emit(id)
            message.emit(id, {"type":"player_state", "player":data.get("player", {})})
        "player_updated":
            message.emit(int(data.get("peer_id", 0)), {"type":"player_state", "player":data.get("player", {})})
        "position":
            message.emit(int(data.get("peer_id", 0)), data)
        "action":
            message.emit(int(data.get("peer_id", 0)), data)
        "chat":
            message.emit(int(data.get("peer_id", 0)), data)
        "world":
            message.emit(0, data)
        "player_left":
            player_left.emit(int(data.get("peer_id", 0)))
        "error":
            message.emit(0, data)
