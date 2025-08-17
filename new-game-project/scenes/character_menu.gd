# CharacterMenu.gd
extends CanvasLayer

@onready var stats_label = $Panel/StatsLabel
@onready var inventory_label = $Panel/InventoryLabel

func update_ui(player):
	var stats = player.stats
	var text = "LEVEL: %d\nHP: %d\nMP: %d\nATK: %d\nDEF: %d\nEXP: %d / %d" % [
		stats["level"], stats["hp"], stats["mp"], stats["attack"], stats["defense"],
		stats["exp"], stats["exp_to_next"]
	]
	stats_label.text = text

	var inv_text = "Inventory:\n"
	for item in player.inventory.keys():
		inv_text += "- %s x%d\n" % [item, player.inventory[item]]
	inventory_label.text = inv_text
