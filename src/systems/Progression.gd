extends Node
class_name Progression

var level := 1
var xp := 0
var max_level := 30

func add_xp(amount: int) -> bool:
    if level >= max_level:
        return false
    xp += amount
    var needed := level * 100
    var leveled := false
    while xp >= needed and level < max_level:
        xp -= needed
        level += 1
        leveled = true
        needed = level * 100
    return leveled

func rank() -> String:
    if level >= 30: return "Guardião"
    if level >= 20: return "Mestre elemental"
    if level >= 10: return "Adepto"
    return "Aprendiz"
