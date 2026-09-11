extends Node
class_name ToxicShopSystem

var catalog := {
    "seed_turnip": {"name": "Semente de Nabo", "buy": 10, "sell": 5},
    "seed_tomato": {"name": "Semente de Tomate", "buy": 18, "sell": 9},
    "seed_moonflower": {"name": "Semente de Flor Lunar", "buy": 35, "sell": 20},
    "small_fish": {"name": "Peixe Pequeno", "buy": 25, "sell": 12},
    "blue_fish": {"name": "Peixe Azul", "buy": 45, "sell": 24},
    "moon_fish": {"name": "Peixe Lunar", "buy": 90, "sell": 55},
    "spirit_shard": {"name": "Fragmento Espiritual", "buy": 140, "sell": 75}
}

func price(item_id: String, selling := false) -> int:
    if not catalog.has(item_id):
        return 0
    return int(catalog[item_id]["sell"] if selling else catalog[item_id]["buy"])
