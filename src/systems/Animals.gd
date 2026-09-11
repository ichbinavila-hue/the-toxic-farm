extends Node
class_name AnimalSystem

signal animal_updated(id, data)

var animals := {
    "chicken_1":{"type":"chicken","happiness":50,"fed":false},
    "cow_1":{"type":"cow","happiness":50,"fed":false}
}

func feed(id: String) -> bool:
    if not animals.has(id):
        return false
    animals[id].fed = true
    animals[id].happiness = min(100, animals[id].happiness + 10)
    animal_updated.emit(id, animals[id])
    return true

func advance_day() -> void:
    for id in animals:
        var a = animals[id]
        if a.fed:
            a.happiness = min(100, a.happiness + 5)
        else:
            a.happiness = max(0, a.happiness - 8)
        a.fed = false
        animals[id] = a
        animal_updated.emit(id, a)
