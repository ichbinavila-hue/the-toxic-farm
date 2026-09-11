extends RefCounted

func run() -> bool:
    var p = Progression.new()
    assert(p.level == 1)
    p.add_xp(100)
    assert(p.level == 2)
    assert(p.rank() == "Aprendiz")
    p.level = 20
    assert(p.rank() == "Mestre elemental")
    return true
