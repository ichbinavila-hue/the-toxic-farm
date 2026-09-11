# The Toxic Farm

Protótipo jogável/arquitetura-base de um RPG cooperativo de fazenda, vida social,
exploração e magia elemental.

## Stack
- Godot 4.x
- GDScript
- Multiplayer ENet
- PC / Steam

## Estado
Este pacote contém uma base completa de projeto para continuar o desenvolvimento:
arquitetura, cenas, scripts, dados dos personagens/elementos, servidor dedicado,
sistemas principais, testes e documentação.

**Importante:** arte pixel-art final, música, efeitos sonoros e conteúdo narrativo
de produção são assets criativos que precisam ser produzidos/substituídos antes
de uma publicação comercial.

## Como abrir
1. Instale Godot 4.x.
2. Abra `project.godot`.
3. Execute a cena principal.
4. Para hospedar: `Main.gd` -> Host.
5. Para entrar: informe o IP do host e use Join.

## Estrutura
- `src/core`: entrada e ciclo principal
- `src/entities`: jogador e personagem
- `src/world`: mundo/fazenda
- `src/systems`: inventário, agricultura, progressão e magia
- `src/network`: multiplayer
- `src/ui`: interface
- `src/data`: dados de jogo
- `docs`: GDD e plano de produção
## Online Web
Consulte `ONLINE_DEPLOY.md`. A pasta `server/websocket` contém o servidor multiplayer WebSocket para até 5 jogadores e `src/network/WebSocketClient.gd` / `WebSocketMultiplayer.gd` a camada cliente.
