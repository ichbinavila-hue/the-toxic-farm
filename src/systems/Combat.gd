extends Node
class_name CombatSystem

signal enemy_defeated(enemy_id)
signal player_damaged(amount)

var enemies := {
    "slime": {"hp":40, "max_hp":40, "damage":8},
    "toxic_slime": {"hp":80, "max_hp":80, "damage":15}
}

func hit(enemy_id: String, power: int) -> bool:
    if not enemies.has(enemy_id):
        return false
    enemies[enemy_id].hp -= power
    if enemies[enemy_id].hp <= 0:
        enemies.erase(enemy_id)
        enemy_defeated.emit(enemy_id)
    return true
