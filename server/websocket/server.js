import http from "node:http";
import { WebSocketServer } from "ws";
import crypto from "node:crypto";

const PORT = Number(process.env.PORT || 8080);
const MAX_PLAYERS = 5;

const server = http.createServer((req, res) => {
  if (req.url === "/health") {
    res.writeHead(200, {"Content-Type": "application/json"});
    res.end(JSON.stringify({
      ok: true,
      game: "The Toxic Farm",
      players: clients.size,
      maxPlayers: MAX_PLAYERS
    }));
    return;
  }
  res.writeHead(200, {"Content-Type": "text/plain"});
  res.end("The Toxic Farm WebSocket server is running.");
});

const wss = new WebSocketServer({server});
const clients = new Map();
let nextId = 1;

const world = {
  day: 1,
  weather: "Sunny",
  region: "farm",
  objects: {},
};

function send(ws, data) {
  if (ws.readyState === ws.OPEN) ws.send(JSON.stringify(data));
}

function broadcast(data, except = null) {
  for (const [ws] of clients) {
    if (ws !== except) send(ws, data);
  }
}

function publicPlayers() {
  const out = {};
  for (const [ws, p] of clients) out[p.id] = p;
  return out;
}

function safeText(value, max = 180) {
  return String(value ?? "").slice(0, max);
}

wss.on("connection", (ws) => {
  if (clients.size >= MAX_PLAYERS) {
    send(ws, {type: "error", message: "Servidor cheio (máximo de 5 jogadores)."});
    ws.close(1013, "Server full");
    return;
  }

  const id = nextId++;
  const player = {
    id,
    name: `Jogador ${id}`,
    character: "Pepitão",
    element: "Spiritual",
    x: 480,
    y: 300,
    region: "farm",
  };
  clients.set(ws, player);

  send(ws, {
    type: "welcome",
    peer_id: id,
    players: publicPlayers(),
    world
  });

  broadcast({type: "player_joined", peer_id: id, player}, ws);

  ws.on("message", (raw) => {
    let msg;
    try {
      msg = JSON.parse(raw.toString());
    } catch {
      return;
    }

    switch (msg.type) {
      case "join":
        player.name = safeText(msg.name || player.name, 32);
        player.character = safeText(msg.character || player.character, 32);
        player.element = safeText(msg.element || player.element, 32);
        broadcast({type: "player_updated", peer_id: id, player});
        break;

      case "position":
        player.x = Number.isFinite(Number(msg.x)) ? Number(msg.x) : player.x;
        player.y = Number.isFinite(Number(msg.y)) ? Number(msg.y) : player.y;
        player.region = safeText(msg.region || player.region, 32);
        broadcast({type: "position", peer_id: id, player}, ws);
        break;

      case "action":
        broadcast({
          type: "action",
          peer_id: id,
          action: safeText(msg.action, 40),
          payload: msg.payload ?? {}
        });
        break;

      case "chat":
        broadcast({
          type: "chat",
          peer_id: id,
          text: safeText(msg.text)
        });
        break;
    }
  });

  ws.on("close", () => {
    clients.delete(ws);
    broadcast({type: "player_left", peer_id: id});
  });
});

setInterval(() => {
  broadcast({type: "world", state: {
    ...world,
    players: publicPlayers()
  }});
}, 1000);

server.listen(PORT, "0.0.0.0", () => {
  console.log(`The Toxic Farm WebSocket server listening on port ${PORT}`);
});
