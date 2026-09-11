extends Node
class_name ToxicWebSocketClient

signal connected
signal disconnected
signal message_received(message: Dictionary)
signal connection_error(message: String)

@export var server_url := "ws://localhost:8080"

var socket := WebSocketPeer.new()
var connected_once := false

func connect_to_server(url := "") -> void:
    if url != "":
        server_url = url
    socket = WebSocketPeer.new()
    var err := socket.connect_to_url(server_url)
    if err != OK:
        connection_error.emit("Falha ao iniciar conexão: %s" % err)
        return
    set_process(true)

func disconnect_from_server() -> void:
    socket.close()
    set_process(false)
    disconnected.emit()

func send_json(data: Dictionary) -> void:
    if socket.get_ready_state() == WebSocketPeer.STATE_OPEN:
        socket.send_text(JSON.stringify(data))

func _process(_delta: float) -> void:
    socket.poll()
    var state := socket.get_ready_state()

    if state == WebSocketPeer.STATE_OPEN:
        if not connected_once:
            connected_once = true
            connected.emit()
        while socket.get_available_packet_count() > 0:
            var packet := socket.get_packet()
            var text := packet.get_string_from_utf8()
            var parsed = JSON.parse_string(text)
            if parsed is Dictionary:
                message_received.emit(parsed)

    elif state == WebSocketPeer.STATE_CLOSED:
        if connected_once:
            connected_once = false
            disconnected.emit()
        set_process(false)
