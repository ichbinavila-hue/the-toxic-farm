# Deploy rápido — Render

A infraestrutura do servidor WebSocket está pronta para o Render.

## Servidor multiplayer

O arquivo `render.yaml` cria um Web Service Docker chamado:

`the-toxic-farm-server`

Ele expõe `/health` e usa a porta fornecida pelo Render através de `PORT`.

Depois do deploy, o Render fornece uma URL pública `https://...onrender.com`.
Para o jogo no navegador, a conexão deve usar:

`wss://...onrender.com`

O Render suporta conexões WebSocket públicas e recomenda `wss` quando o cliente está na internet. citeturn0search1

## Jogo Web

A exportação Godot Web deve ser publicada como conteúdo estático. Cloudflare Pages, por exemplo, aceita sites HTML estáticos e fornece um domínio `*.pages.dev`. citeturn0search0

Fluxo final:

Jogador
  ↓ HTTPS
The Toxic Farm Web
  ↓ WSS
Render Web Service
  ↓
Node.js WebSocket

## O que ainda precisa de uma conta externa

Para obter um endereço público real, o projeto precisa ser enviado a uma conta Git/hosting e o serviço precisa ser criado. O pacote contém toda a configuração para isso, mas esta sessão não possui autorização para criar uma conta externa ou publicar no seu nome.

Depois que o serviço estiver publicado, substitua no cliente:

`ws://localhost:8080`

por:

`wss://SEU-SERVICO.onrender.com`

## Deploy pelo painel

1. Coloque este projeto em um repositório Git.
2. No Render, crie um Web Service a partir do repositório.
3. Use o `render.yaml`/Dockerfile.
4. Faça o deploy.
5. Copie a URL `onrender.com`.
6. Configure o cliente Godot com `wss://...`.
7. Publique a pasta `web/build` em um host HTTPS.

O Render fornece URLs `onrender.com` para Web Services e pode construir o serviço diretamente do Dockerfile. citeturn0search3turn0search6
