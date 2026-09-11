# Multiplayer

## Protótipo
ENet, porta 24567, máximo 5 jogadores.

## Produção recomendada
Servidor dedicado autoritativo.

### Autoridade
Servidor controla:
- posição válida
- colisões relevantes
- inventário
- economia
- crescimento de plantas
- drops
- inimigos
- dano
- progressão
- eventos

Cliente controla:
- input
- câmera
- efeitos locais
- UI

## Segurança
Nunca aceitar do cliente:
- quantidade arbitrária de dinheiro
- XP arbitrário
- item arbitrário
- dano arbitrário
- teleport arbitrário

## Reconexão
Guardar estado do jogador e permitir reconexão dentro de uma janela definida.

## Sessão
1 host cria mundo
2 jogadores entram
3 servidor envia estado inicial
4 clientes enviam input
5 servidor simula
6 servidor replica estado
