extends Node
class_name ElementData

const ELEMENTS := {
    "fire":{"name":"Fogo","ability":"Chama Explosiva","role":"Ataque, mineração"},
    "water":{"name":"Água","ability":"Fonte Vital","role":"Cura, pesca, agricultura"},
    "nature":{"name":"Natureza","ability":"Crescimento","role":"Plantas, animais, regeneração"},
    "lightning":{"name":"Raio","ability":"Sobrecarga","role":"Velocidade, tecnologia"},
    "air":{"name":"Ar","ability":"Impulso","role":"Mobilidade, exploração"},
    "earth":{"name":"Terra","ability":"Muralha","role":"Defesa, construção"},
    "spiritual":{"name":"Espiritual","ability":"Visão Astral","role":"Espíritos, mistérios"}
}

static func get_element(id: String) -> Dictionary:
    return ELEMENTS.get(id, ELEMENTS["spiritual"])

static func combo(a: String, b: String) -> String:
    var pair := [a,b]
    pair.sort()
    var key := "%s+%s" % [pair[0],pair[1]]
    return {
        "fire+lightning":"Plasma",
        "nature+water":"Vida",
        "earth+nature":"Natureza Ancestral",
        "air+fire":"Tempestade de Fogo",
        "lightning+water":"Eletrocussão",
        "earth+fire":"Magma"
    }.get(key, "Magia Combinada")
