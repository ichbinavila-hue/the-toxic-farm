extends RefCounted

func run() -> bool:
    assert(ElementData.combo("fire","lightning") == "Plasma")
    assert(ElementData.combo("water","nature") == "Vida")
    assert(ElementData.get_element("air").name == "Ar")
    return true
