extends Node
class_name ToxicNetwork

signal player_joined(peer_id)
signal player_left(peer_id)
signal message(peer_id, data)

const PORT := 24567
const MAX_PLAYERS := 5
var peer: ENetMultiplayerPeer

func host_game() -> void:
    peer = ENetMultiplayerPeer.new()
    var err = peer.create_server(PORT, MAX_PLAYERS)
    if err != OK:
        push_error("Falha ao criar servidor: %s" % err)
        return
    multiplayer.multiplayer_peer = peer
    multiplayer.peer_connected.connect(_on_peer_connected)
    multiplayer.peer_disconnected.connect(_on_peer_disconnected)
    _on_peer_connected(1)

func join_game(ip: String) -> void:
    peer = ENetMultiplayerPeer.new()
    var err = peer.create_client(ip, PORT)
    if err != OK:
        push_error("Falha ao conectar: %s" % err)
        return
    multiplayer.multiplayer_peer = peer

func _on_peer_connected(id: int) -> void:
    player_joined.emit(id)

func _on_peer_disconnected(id: int) -> void:
    player_left.emit(id)

func send_message(data: Dictionary) -> void:
    if multiplayer.multiplayer_peer == null:
        return
    if multiplayer.is_server():
        _receive_message.rpc(1, data)
    else:
        _receive_message.rpc_id(1, data)

@rpc("any_peer", "reliable")
func _receive_message(sender: int, data: Dictionary) -> void:
    message.emit(sender, data)
