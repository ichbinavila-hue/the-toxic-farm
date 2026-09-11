# Game Design Document — The Toxic Farm

## Core
RPG cooperativo online para até 5 jogadores. A propriedade é compartilhada,
mas cada jogador possui espaço pessoal.

## Sistemas
1. Agricultura
2. Animais
3. Pesca
4. Mineração
5. Construção
6. Culinária
7. Inventário
8. Progressão
9. Magia elemental
10. Combate
11. NPCs e amizade
12. Eventos
13. Exploração
14. Região espiritual
15. Multiplayer

## Progressão
Nível 1 Aprendiz -> 10 Adepto -> 20 Mestre elemental -> 30 Guardião.

## Combos
Fogo+Raio=Plasma
Natureza+Água=Vida
Terra+Natureza=Natureza Ancestral
Ar+Fogo=Tempestade de Fogo
Água+Raio=Eletrocussão
Terra+Fogo=Magma
Espiritual+qualquer=Magia Espiritual

## Arquitetura de rede
Servidor autoritativo é o objetivo de produção. O protótipo usa ENet e limita
a sala a 5 jogadores. Para lançamento, validação de movimento, inventário,
agricultura, combate e drops deve acontecer no servidor.

## Salvamento
Produção: save por mundo + perfil por jogador, com versionamento e migração.
Nunca confiar em estado enviado pelo cliente.

## Arte
Pixel art original, sem copiar artistas, marcas ou personagens reais.
Cantora favorita de Felipa deve ser uma personagem fictícia.

## Conteúdo de produção
Ainda precisam ser adicionados assets finais: sprites, tilesets, animações,
efeitos, música, SFX, retratos, ícones e arte promocional.
