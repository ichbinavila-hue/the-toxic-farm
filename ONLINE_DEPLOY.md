# The Toxic Farm — Web + Multiplayer

## 1. Exportar o jogo Web

É necessário ter o **Godot 4.x** instalado.

Linux/macOS:
```bash
GODOT_BIN=godot ./tools/build_web.sh
```

Windows PowerShell:
```powershell
$env:GODOT_BIN="godot.exe"
.\tools\build_web.ps1
```

O resultado fica em:
`web/build/index.html`

A pasta `web/build/` deve ser servida por HTTPS/HTTP através de um servidor web; não abra o `index.html` diretamente pelo arquivo.

## 2. Rodar o servidor multiplayer local

```bash
cd server/websocket
npm install
npm start
```

Servidor:
`ws://localhost:8080`

Teste:
abra `web/online_test.html` através de um servidor HTTP local e conecte em `ws://localhost:8080`.

## 3. Docker

```bash
cd server/websocket
docker compose up -d --build
```

## 4. Publicar online

Recomendação:
- hospedagem Web: qualquer host estático/CDN que sirva a exportação Godot;
- servidor multiplayer: VPS/container com Node.js;
- domínio: `wss://server.seudominio.com`;
- proxy reverso: Nginx/Caddy;
- HTTPS obrigatório para o jogo Web quando ele estiver em HTTPS.

Exemplo conceitual:

Browser
  ↓ HTTPS
Game Web
  ↓ WSS
Reverse Proxy
  ↓
Node.js WebSocket Server :8080

O servidor atual limita a 5 jogadores por instância e mantém posição, personagem, elemento, região e mensagens de chat.

## 5. Limitações atuais

Esta primeira camada online é um servidor de sessão/prototipagem. Para produção ainda precisamos:
- autenticação;
- validação anti-cheat no servidor;
- persistência de contas/saves;
- instâncias/lobbies;
- reconexão;
- autoridade de combate e economia;
- rate limiting;
- banco de dados;
- TLS/WSS no deploy;
- monitoramento.

A arquitetura foi feita para permitir essa evolução sem abandonar o projeto Godot.
