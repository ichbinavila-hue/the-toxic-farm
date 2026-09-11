extends Node
class_name ToxicQuestSystem

var quests := {
    "first_harvest": {
        "title": "Primeira Colheita",
        "description": "Colha 3 plantações na fazenda.",
        "target": 3,
        "progress": 0,
        "reward": {"gold": 80, "xp": 40}
    },
    "meet_village": {
        "title": "Conheça a Vila",
        "description": "Visite a Vila e fale com um morador.",
        "target": 1,
        "progress": 0,
        "reward": {"gold": 50, "xp": 25}
    },
    "mine_depths": {
        "title": "Rumo às Profundezas",
        "description": "Colete 5 minérios nas minas.",
        "target": 5,
        "progress": 0,
        "reward": {"gold": 120, "xp": 70}
    },
    "spirit_signal": {
        "title": "Sinal Espiritual",
        "description": "Colete 2 fragmentos espirituais.",
        "target": 2,
        "progress": 0,
        "reward": {"gold": 160, "xp": 100}
    }
}

signal_quest_updated = Signal()

func reset() -> void:
    for q in quests.values():
        q.progress = 0
    signal_quest_updated.emit()

func add_progress(id: String, amount: int = 1) -> bool:
    if not quests.has(id):
        return false
    var q = quests[id]
    if q.progress >= q.target:
        return false
    q.progress = min(q.target, q.progress + amount)
    signal_quest_updated.emit()
    return true

func is_complete(id: String) -> bool:
    return quests.has(id) and quests[id].progress >= quests[id].target

func get_active() -> Array:
    var out: Array = []
    for id in quests.keys():
        if not is_complete(id):
            out.append({"id": id, "data": quests[id]})
    return out

func get_completed() -> Array:
    var out: Array = []
    for id in quests.keys():
        if is_complete(id):
            out.append({"id": id, "data": quests[id]})
    return out
