extends Node3D

# --- UI References ---
@onready var save_button = $CanvasLayer/Control/save
@onready var show_inventory_button = $CanvasLayer/Control/inventory
@onready var show_menu_button = $CanvasLayer/Control/ShowMenuButton

# --- Player and Character Menu ---
@onready var player = $MeshInstance3D
@onready var character_menu = $CharacterMenu

# --- Pause Menu ---
@onready var pause_menu = $PauseMenu
@onready var resume_button = $PauseMenu/Panel/ResumeButton
@onready var load_button = $PauseMenu/Panel/LoadButton
@onready var main_menu_button = $PauseMenu/Panel/MainMenuButton
@onready var save_pause_button = $PauseMenu/Panel/SaveButton  # optional if used

func _ready():
	print("Game scene loaded.")
	print("Loaded save data: ", SaveManager.save_data)

	# --- Load Player Data ---
	if SaveManager.save_data.has("player_position"):
		var pos_dict = SaveManager.save_data["player_position"]
		player.position = Vector3(pos_dict.x, pos_dict.y, pos_dict.z)

	if SaveManager.save_data.has("inventory"):
		player.inventory = SaveManager.save_data["inventory"]

	if SaveManager.save_data.has("stats"):
		player.stats = SaveManager.save_data["stats"]

	# --- Connect Main UI Buttons ---
	save_button.pressed.connect(save_game)
	show_inventory_button.pressed.connect(show_inventory)
	show_menu_button.pressed.connect(toggle_character_menu)

	# --- Connect Pause Menu Buttons ---
	resume_button.pressed.connect(toggle_pause_menu)
	load_button.pressed.connect(load_game)
	main_menu_button.pressed.connect(go_to_main_menu)
	if save_pause_button:
		save_pause_button.pressed.connect(save_game)

	# --- Hide Pause Menu on Start ---
	pause_menu.visible = false

func _input(event):
	if event.is_action_pressed("ui_cancel"):  # ESC key
		toggle_pause_menu()

func toggle_pause_menu():
	var is_paused = get_tree().paused
	get_tree().paused = !is_paused
	pause_menu.visible = !is_paused
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED if is_paused else Input.MOUSE_MODE_VISIBLE)

func save_game():
	var position = player.global_position
	SaveManager.save_game(position, player.inventory, player.stats)
	print("Game saved at position: ", position)

func load_game():
	if SaveManager.load_game():
		var pos_dict = SaveManager.save_data["player_position"]
		player.global_position = Vector3(pos_dict.x, pos_dict.y, pos_dict.z)

		player.inventory = SaveManager.save_data.get("inventory", {})
		player.stats = SaveManager.save_data.get("stats", {})

		print("Game loaded!")
		toggle_pause_menu()  # Auto-unpause after loading
	else:
		print("No save file found!")

func show_inventory():
	print("Player inventory:")
	for item in player.inventory:
		print("- %s x%d" % [item, player.inventory[item]])

func toggle_character_menu():
	character_menu.visible = !character_menu.visible
	if character_menu.visible:
		character_menu.update_ui(player)

func go_to_main_menu():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
