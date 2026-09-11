extends Node2D
class_name ToxicNPC

@export var npc_id := "mara"
var friendship := 0
var dialogue_index := 0

const DATA := {
    "mara":{"name":"Mara","role":"Mercadora","lines":["A fazenda voltou a ter vida.","Ouvi sons estranhos na floresta.","Talvez a mina esconda uma resposta."]},
    "téo":{"name":"Téo","role":"Pescador","lines":["A maré está estranha hoje.","Peixes lunares aparecem em noites especiais.","Você já ouviu falar da praia antiga?"]},
    "luna":{"name":"Luna","role":"Guardião da biblioteca","lines":["Os símbolos elementais são muito antigos.","Há registros sobre a fazenda.","Não confie em tudo que os espíritos dizem."]}
}

func talk() -> String:
    var d: Dictionary = DATA.get(npc_id, DATA["mara"])
    var lines: Array = d.lines
    var line: String = lines[dialogue_index % lines.size()]
    dialogue_index += 1
    friendship += 1
    return "%s: %s" % [d.name, line]
